import 'package:fluentzy/data/repositories/flash_card_repository.dart';
import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:fluentzy/data/repositories/stt_repository.dart';
import 'package:fluentzy/data/repositories/translation_repository.dart';
import 'package:fluentzy/data/repositories/tts_repository.dart';
import 'package:fluentzy/data/services/preference_service.dart';
import 'package:fluentzy/routing/app_route_path.dart';
import 'package:fluentzy/routing/auth_routes.dart';
import 'package:fluentzy/routing/flash_card_routes.dart';
import 'package:fluentzy/routing/home_routes.dart';
import 'package:fluentzy/routing/listening_routes.dart';
import 'package:fluentzy/routing/quiz_routes.dart';
import 'package:fluentzy/routing/scanner_routes.dart';
import 'package:fluentzy/routing/speaking_routes.dart';
import 'package:fluentzy/ui/language/language_screen.dart';
import 'package:fluentzy/ui/main/main_screen.dart';
import 'package:fluentzy/ui/statistics/statistics_screen.dart';
import 'package:fluentzy/ui/statistics/statistics_view_model.dart';
import 'package:fluentzy/ui/translator/translator_screen.dart';
import 'package:fluentzy/ui/translator/translator_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutePath.login,
    navigatorKey: _rootNavigatorKey,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainScreen(uri: state.uri, child: child);
        },
        routes: homeRoutes,
      ),
      ...authRoutes,
      GoRoute(
        path: AppRoutePath.language,
        builder: (context, state) => LanguageScreen(),
      ),
      GoRoute(
        path: AppRoutePath.translator,
        builder:
            (context, state) => ChangeNotifierProvider(
              create:
                  (context) => TranslatorViewModel(
                    context.read<TranslationRepository>(),
                    context.read<TtsRepository>(),
                    context.read<SttRepository>(),
                  ),
              child: TranslatorScreen(),
            ),
      ),
      GoRoute(
        path: AppRoutePath.statistics,
        builder:
            (context, state) => ChangeNotifierProvider(
              create:
                  (context) => StatisticsViewModel(
                    context.read<PreferenceService>(),
                    context.read<LessonRepository>(),
                    context.read<FlashCardRepository>(),
                  ),
              child: StatisticsScreen(),
            ),
      ),
      ...speakingRoutes,
      ...scannerRoutes,
      ...listeningRoutes,
      ...flashCardRoutes,
      ...quizRoutes,
    ],
  );
}
