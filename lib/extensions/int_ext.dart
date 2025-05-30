import 'dart:ui';

import 'package:fluentzy/ui/core/app_colors.dart';

extension DurationExtension on int {
  String toDurationString() {
    final hours = this ~/ 3600;
    final minutes = (this % 3600) ~/ 60;
    final secs = this % 60;
    final formattedHours = hours > 0 ? '$hours:' : '';
    final formattedMinutes = minutes.toString().padLeft(2, '0');
    final formattedSeconds = secs.toString().padLeft(2, '0');
    return '$formattedHours$formattedMinutes:$formattedSeconds';
  }

  Color getAccuracyColor() {
    if (this == 0) return AppColors.error;
    if (this < 20) return AppColors.veryPoor;
    if (this < 40) return AppColors.poor;
    if (this < 60) return AppColors.fair;
    if (this < 75) return AppColors.average;
    if (this < 85) return AppColors.good;
    if (this < 95) return AppColors.veryGood;
    return AppColors.success;
  }
}