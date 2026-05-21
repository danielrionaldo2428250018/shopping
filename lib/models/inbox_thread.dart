import 'dart:convert';

/// Satu bubble percakapan (gaya WhatsApp).
class InboxMessage {
  InboxMessage({
    required this.id,
    required this.text,
    required this.sentAt,
    required this.isOutbound,
  });

  final String id;
  final String text;
  final DateTime sentAt;

  /// true = pesan dari Anda (kanan), false = dari sistem / penjual (kiri).
  final bool isOutbound;

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'sentAt': sentAt.toIso8601String(),
        'isOutbound': isOutbound,
      };

  factory InboxMessage.fromJson(Map<String, dynamic> m) {
    return InboxMessage(
      id: m['id'] as String,
      text: m['text'] as String,
      sentAt: DateTime.parse(m['sentAt'] as String),
      isOutbound: m['isOutbound'] as bool? ?? false,
    );
  }
}

/// Thread percakapan (satu baris di daftar seperti WhatsApp).
class InboxThread {
  InboxThread({
    required this.id,
    required this.title,
    required this.avatarLetter,
    required this.messages,
    this.routeOnOpen,
    this.accentArgb,
    this.unreadCount = 0,
  });

  final String id;
  final String title;
  final String avatarLetter;
  final List<InboxMessage> messages;

  /// Opsional: tap "buka halaman" dari sheet lama.
  final String? routeOnOpen;
  final int? accentArgb;
  int unreadCount;

  bool get hasUnread => unreadCount > 0;

  InboxMessage get lastMessage => messages.last;

  String get preview => lastMessage.text;

  DateTime get lastAt => lastMessage.sentAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'avatarLetter': avatarLetter,
        'routeOnOpen': routeOnOpen,
        'accentArgb': accentArgb,
        'unreadCount': unreadCount,
        'messages': messages.map((e) => e.toJson()).toList(),
      };

  factory InboxThread.fromJson(Map<String, dynamic> m) {
    final raw = m['messages'] as List<dynamic>? ?? [];
    return InboxThread(
      id: m['id'] as String,
      title: m['title'] as String,
      avatarLetter: m['avatarLetter'] as String? ?? '?',
      routeOnOpen: m['routeOnOpen'] as String?,
      accentArgb: m['accentArgb'] as int?,
      unreadCount: (m['unreadCount'] as num?)?.toInt() ?? 0,
      messages: raw
          .map((e) => InboxMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  InboxThread copyWith({
    List<InboxMessage>? messages,
    int? unreadCount,
  }) {
    return InboxThread(
      id: id,
      title: title,
      avatarLetter: avatarLetter,
      routeOnOpen: routeOnOpen,
      accentArgb: accentArgb,
      unreadCount: unreadCount ?? this.unreadCount,
      messages: messages ?? List.from(this.messages),
    );
  }
}

String inboxThreadsToJson(List<InboxThread> threads) =>
    jsonEncode(threads.map((e) => e.toJson()).toList());

List<InboxThread> inboxThreadsFromJson(String s) {
  final list = jsonDecode(s) as List<dynamic>;
  return list.map((e) => InboxThread.fromJson(e as Map<String, dynamic>)).toList();
}

/// Daftar percakapan kosong — isi dari push / pesanan / chat nanti.
List<InboxThread> defaultInboxThreads() => [];
