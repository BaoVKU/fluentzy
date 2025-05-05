import 'dart:ui';

import 'package:fluentzy/ui/core/app_colors.dart';

enum HomeFeature {
  speaking(
    name: "Speaking",
    backgroundColor: AppColors.speakingBackground,
    iconPath: "assets/speak.svg",
  ),
  listening(
    name: "Listening",
    backgroundColor: AppColors.listeningBackground,
    iconPath: "assets/headphone.svg",
  ),
  scanner(
    name: "Scanner",
    backgroundColor: AppColors.scannerBackground,
    iconPath: "assets/scan.svg",
  ),
  flashCard(
    name: "Flash Card",
    backgroundColor: AppColors.flashCardBackground,
    iconPath: "assets/flash_card.svg",
  );

  final String name;
  final Color backgroundColor;
  final String iconPath;
  const HomeFeature({
    required this.name,
    required this.backgroundColor,
    required this.iconPath,
  });
}
