import 'package:fluentzy/routing/paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavigationDestinations {
  static List<NavigationDestination> list = [
    NavigationDestination(
      icon: SvgPicture.asset('assets/home.svg', width: 24, height: 24),
      label: 'Home',
    ),
    NavigationDestination(
      icon: SvgPicture.asset('assets/premium.svg', width: 24, height: 24),
      label: 'Premium',
    ),
    NavigationDestination(
      icon: SvgPicture.asset('assets/chat.svg', width: 24, height: 24),
      label: 'Chat',
    ),
    NavigationDestination(
      icon: SvgPicture.asset('assets/profile.svg', width: 24, height: 24),
      label: 'Profile',
    ),
  ];
  static List paths = [
    RoutePath.home,
    RoutePath.premium,
    RoutePath.chat,
    RoutePath.profile,
  ];
}
