import 'package:fluentzy/routing/paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavigationDestinations {
  static List<NavigationDestination> getList(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return [
      NavigationDestination(
        icon: SvgPicture.asset('assets/home.svg', width: 24, height: 24),
        label: localizations.home,
      ),
      NavigationDestination(
        icon: SvgPicture.asset('assets/premium.svg', width: 24, height: 24),
        label: "Premium",
      ),
      NavigationDestination(
        icon: SvgPicture.asset('assets/chat.svg', width: 24, height: 24),
        label: localizations.chat,
      ),
      NavigationDestination(
        icon: SvgPicture.asset('assets/profile.svg', width: 24, height: 24),
        label: localizations.profile,
      ),
    ];
  }

  static List paths = [
    RoutePath.home,
    RoutePath.premium,
    RoutePath.chat,
    RoutePath.profile,
  ];
}
