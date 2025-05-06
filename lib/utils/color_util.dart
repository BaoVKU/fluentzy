import 'dart:ui';

import 'package:fluentzy/ui/core/app_colors.dart';

class ColorPicker {
  static Color getColorForAccuracy(int? rate) {
    if (rate == null) return AppColors.error;
    if (rate < 20) return AppColors.veryPoor;
    if (rate < 40) return AppColors.poor;
    if (rate < 60) return AppColors.fair;
    if (rate < 75) return AppColors.average;
    if (rate < 85) return AppColors.good;
    if (rate < 95) return AppColors.veryGood;
    return AppColors.success;
  }
}
