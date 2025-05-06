import 'dart:ui';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum HomeFeature {
  speaking(
    backgroundColor: AppColors.speakingBackground,
    iconPath: "assets/speak.svg",
  ),
  listening(
    backgroundColor: AppColors.listeningBackground,
    iconPath: "assets/headphone.svg",
  ),
  scanner(
    backgroundColor: AppColors.scannerBackground,
    iconPath: "assets/scan.svg",
  ),
  flashCard(
    backgroundColor: AppColors.flashCardBackground,
    iconPath: "assets/flash_card.svg",
  );

  final Color backgroundColor;
  final String iconPath;
  const HomeFeature({required this.backgroundColor, required this.iconPath});

  static String getLocalizedName(BuildContext context, HomeFeature feature) {
    final l10n = AppLocalizations.of(context)!;
    switch (feature) {
      case HomeFeature.speaking:
        return l10n.speaking;
      case HomeFeature.listening:
        return l10n.listening;
      case HomeFeature.scanner:
        return l10n.scanner; // or any better-matching key
      case HomeFeature.flashCard:
        return l10n.flashCard; // or just `l10n.flashCard` if available
    }
  }
}
