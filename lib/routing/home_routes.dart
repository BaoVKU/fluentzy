import 'package:fluentzy/data/repositories/ai_repository.dart';
import 'package:fluentzy/data/repositories/auth_repository.dart';
import 'package:fluentzy/data/repositories/iap_repository.dart';
import 'package:fluentzy/data/services/preference_service.dart';
import 'package:fluentzy/routing/app_route_path.dart';
import 'package:fluentzy/ui/chat/chat_screen.dart';
import 'package:fluentzy/ui/chat/chat_view_model.dart';
import 'package:fluentzy/ui/home/home_page.dart';
import 'package:fluentzy/ui/premium/premium_page.dart';
import 'package:fluentzy/ui/premium/premium_view_model.dart';
import 'package:fluentzy/ui/profile/profile_page.dart';
import 'package:fluentzy/ui/profile/profile_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final homeRoutes = [
  GoRoute(path: AppRoutePath.home, builder: (context, state) => HomePage()),
  GoRoute(
    path: AppRoutePath.premium,
    builder:
        (context, state) => ChangeNotifierProvider(
          create: (context) => PremiumViewModel(context.read<IapRepository>()),
          child: const PremiumPage(),
        ),
  ),
  GoRoute(
    path: AppRoutePath.chat,
    builder:
        (context, state) => ChangeNotifierProvider(
          create: (context) => ChatViewModel(context.read<AiRepository>()),
          child: ChatScreen(),
        ),
  ),
  GoRoute(
    path: AppRoutePath.profile,
    builder:
        (context, state) => ChangeNotifierProvider(
          create:
              (context) => ProfileViewModel(
                context.read<PreferenceService>(),
                context.read<AuthRepository>(),
              ),
          child: const ProfilePage(),
        ),
  ),
];
