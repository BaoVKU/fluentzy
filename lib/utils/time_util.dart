class TimeUtil {
  static String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    final formattedHours = hours > 0 ? '$hours:' : '';
    final formattedMinutes = minutes.toString().padLeft(2, '0');
    final formattedSeconds = secs.toString().padLeft(2, '0');
    return '$formattedHours$formattedMinutes:$formattedSeconds';
  }
}
