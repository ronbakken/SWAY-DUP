import 'dart:ui' show Path, PathMetric, Offset;

Path trimPath(Path source, double percentage) {
  /// WARNING: computeMetrics returns a iterator that can only be used ONCE!

  percentage = percentage.clamp(0.0, 1.0);
  if (percentage == 0.0) return Path();
  if (percentage == 1.0) return Path.from(source);

  final dest = Path();
  final target = source.computeMetrics().fold(0.0, (value, metric) => value + metric.length) * percentage;

  double start = 0.0;
  for (final PathMetric metric in source.computeMetrics()) {
    if (start > target) {
      break;
    }
    final length = (target - start).clamp(0.0, metric.length);
    dest.addPath(metric.extractPath(0.0, length), Offset.zero);
    start += metric.length;
  }

  return dest;
}
