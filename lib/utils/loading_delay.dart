/// Menjaga UX saat jaringan lambat: pastikan indikator loading tampil minimal
/// [minDisplay] supaya tidak berkedip terlalu cepat, dan beri jeda tambahan ringan
/// jika tugas selesai sangat cepat (efek "sinyal stabil").
Future<T> withMinimumLoadingDuration<T>(
  Future<T> future, {
  Duration minDisplay = const Duration(milliseconds: 520),
}) async {
  final sw = Stopwatch()..start();
  try {
    return await future;
  } finally {
    sw.stop();
    final left = minDisplay - sw.elapsed;
    if (left > Duration.zero) {
      await Future<void>.delayed(left);
    }
  }
}
