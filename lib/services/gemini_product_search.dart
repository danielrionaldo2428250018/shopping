import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../config/gemini_config.dart';
import '../data/catalog_data.dart';
import '../models/catalog_product.dart';

/// Hasil pencarian produk dari foto via Gemini Vision.
class GeminiPhotoSearchResult {
  const GeminiPhotoSearchResult({
    required this.detectedName,
    required this.productIds,
    required this.keywords,
  });

  final String detectedName;
  final List<String> productIds;
  final String keywords;
}

/// Mengenali barang dari foto dengan Gemini, lalu mencocokkan ke katalog lokal.
class GeminiProductSearch {
  GeminiProductSearch._();

  static Future<GeminiPhotoSearchResult> searchByPhotoBytes(
    Uint8List bytes,
  ) async {
    if (!GeminiConfig.isConfigured) {
      throw StateError(
        'GEMINI_API_KEY belum diatur. Jalankan dengan '
        '--dart-define=GEMINI_API_KEY=...',
      );
    }
    if (kCatalogProducts.isEmpty) {
      throw StateError(
        'Katalog produk masih kosong. Tambahkan produk dulu untuk pencarian foto.',
      );
    }

    final catalogLines = kCatalogProducts
        .map(
          (p) =>
              '- id: "${p.id}", judul: "${p.title}", kategori: ${p.category}',
        )
        .join('\n');

    final base64Image = base64Encode(bytes);

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {
              'inlineData': {
                'mimeType': 'image/jpeg',
                'data': base64Image,
              },
            },
            {
              'text':
                  'Anda adalah asisten marketplace barang bekas (preloved). '
                  'Lihat foto ini dan tentukan barang apa yang paling dominan.\n\n'
                  'Katalog produk yang tersedia (pilih HANYA id dari daftar ini):\n'
                  '$catalogLines\n\n'
                  'Balas HANYA dengan JSON valid tanpa markdown, format:\n'
                  '{"namaBarang":"nama singkat dalam Bahasa Indonesia",'
                  '"kataKunci":"2-5 kata untuk pencarian",'
                  '"productIds":["id1","id2"]}\n\n'
                  'Urutkan productIds dari paling cocok (maks 4 id). '
                  'Jika tidak yakin, pilih id yang paling mirip kategori/warna/jenis barang.',
            },
          ],
        },
      ],
    });

    final response = await http.post(
      Uri.parse(GeminiConfig.generateContentUrl),
      headers: {
        'x-goog-api-key': GeminiConfig.apiKey,
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gemini HTTP ${response.statusCode}: ${response.body}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final text = _extractText(json);
    if (text == null || text.trim().isEmpty) {
      throw Exception('Respons Gemini kosong');
    }

    final parsed = _parseAiJson(text);
    final ids = _filterValidIds(parsed.productIds);
    final name = parsed.detectedName.trim().isNotEmpty
        ? parsed.detectedName.trim()
        : parsed.keywords;

    if (ids.isEmpty) {
      final fallback = catalogSearch(name);
      return GeminiPhotoSearchResult(
        detectedName: name,
        keywords: parsed.keywords,
        productIds: fallback.map((p) => p.id).toList(),
      );
    }

    return GeminiPhotoSearchResult(
      detectedName: name,
      keywords: parsed.keywords,
      productIds: ids,
    );
  }

  static String? _extractText(Map<String, dynamic> json) {
    final candidates = json['candidates'];
    if (candidates is! List || candidates.isEmpty) return null;
    final content = candidates.first['content'];
    if (content is! Map) return null;
    final parts = content['parts'];
    if (parts is! List || parts.isEmpty) return null;
    final part = parts.first;
    if (part is Map && part['text'] is String) {
      return part['text'] as String;
    }
    return null;
  }

  static GeminiPhotoSearchResult _parseAiJson(String raw) {
    var s = raw.trim();
    if (s.startsWith('```')) {
      s = s.replaceAll(RegExp(r'^```(?:json)?\s*'), '');
      s = s.replaceAll(RegExp(r'\s*```$'), '');
    }
    final start = s.indexOf('{');
    final end = s.lastIndexOf('}');
    if (start < 0 || end <= start) {
      return GeminiPhotoSearchResult(
        detectedName: s,
        keywords: s,
        productIds: const [],
      );
    }
    final map = jsonDecode(s.substring(start, end + 1)) as Map<String, dynamic>;
    final idsRaw = map['productIds'];
    final ids = <String>[];
    if (idsRaw is List) {
      for (final e in idsRaw) {
        if (e != null) ids.add(e.toString());
      }
    }
    return GeminiPhotoSearchResult(
      detectedName: (map['namaBarang'] ?? map['name'] ?? '').toString(),
      keywords: (map['kataKunci'] ?? map['keywords'] ?? '').toString(),
      productIds: ids,
    );
  }

  static List<String> _filterValidIds(List<String> ids) {
    final valid = <String>{};
    for (final p in kCatalogProducts) {
      valid.add(p.id);
    }
    return ids.where(valid.contains).toList();
  }

  /// Gabungkan hasil Gemini dengan peringkat visual sebagai cadangan.
  static List<CatalogProduct> mergeWithVisualFallback({
    required List<String> geminiIds,
    required List<CatalogProduct> visualRanked,
  }) {
    final out = <CatalogProduct>[];
    final seen = <String>{};
    for (final id in geminiIds) {
      final p = catalogProductById(id);
      if (p != null && seen.add(p.id)) out.add(p);
    }
    for (final p in visualRanked) {
      if (seen.add(p.id)) out.add(p);
    }
    return out.isEmpty ? List<CatalogProduct>.from(kCatalogProducts) : out;
  }
}
