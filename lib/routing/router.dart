import 'package:camera/camera.dart';
import 'package:fluentzy/data/models/flash_card_set.dart';
import 'package:fluentzy/data/repositories/ai_repository.dart';
import 'package:fluentzy/data/repositories/auth_repository.dart';
import 'package:fluentzy/data/repositories/dictionary_repository.dart';
import 'package:fluentzy/data/repositories/flash_card_repository.dart';
import 'package:fluentzy/data/repositories/iap_repository.dart';
import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:fluentzy/data/repositories/stt_repository.dart';
import 'package:fluentzy/data/repositories/translation_repository.dart';
import 'package:fluentzy/data/repositories/tts_repository.dart';
import 'package:fluentzy/data/services/audio_service.dart';
import 'package:fluentzy/data/services/camera_service.dart';
import 'package:fluentzy/data/services/image_picker_service.dart';
import 'package:fluentzy/routing/paths.dart';
import 'package:fluentzy/ui/chat/chat_screen.dart';
import 'package:fluentzy/ui/chat/chat_view_model.dart';
import 'package:fluentzy/ui/flash_card/edit/edit_screen.dart';
import 'package:fluentzy/ui/flash_card/edit/edit_view_model.dart';
import 'package:fluentzy/ui/flash_card/learn/learn_screen.dart';
import 'package:fluentzy/ui/flash_card/learn/learn_view_model.dart';
import 'package:fluentzy/ui/flash_card/list/list_screen.dart';
import 'package:fluentzy/ui/flash_card/list/list_view_model.dart';
import 'package:fluentzy/ui/home/home_page.dart';
import 'package:fluentzy/ui/language/language_screen.dart';
import 'package:fluentzy/ui/listening/lesson/lesson_screen.dart';
import 'package:fluentzy/ui/listening/play/play_screen.dart';
import 'package:fluentzy/ui/listening/play/play_view_model.dart';
import 'package:fluentzy/ui/login/login_screen.dart';
import 'package:fluentzy/ui/login/login_view_model.dart';
import 'package:fluentzy/ui/main/main_screen.dart';
import 'package:fluentzy/ui/premium/premium_page.dart';
import 'package:fluentzy/ui/premium/premium_view_model.dart';
import 'package:fluentzy/ui/profile/profile_page.dart';
import 'package:fluentzy/ui/profile/profile_view_model.dart';
import 'package:fluentzy/ui/quiz/learn/learn_screen.dart';
import 'package:fluentzy/ui/quiz/learn/learn_view_model.dart';
import 'package:fluentzy/ui/register/register_screen.dart';
import 'package:fluentzy/ui/register/register_view_model.dart';
import 'package:fluentzy/ui/scanner/camera/camera_screen.dart';
import 'package:fluentzy/ui/scanner/camera/camera_view_model.dart';
import 'package:fluentzy/ui/scanner/crop/crop_screen.dart';
import 'package:fluentzy/ui/scanner/crop/crop_view_model.dart';
import 'package:fluentzy/ui/scanner/option/option_screen.dart';
import 'package:fluentzy/ui/scanner/option/option_view_model.dart';
import 'package:fluentzy/ui/scanner/result/result_screen.dart';
import 'package:fluentzy/ui/speaking/lesson/lesson_screen.dart';
import 'package:fluentzy/ui/speaking/lesson/lesson_view_model.dart';
import 'package:fluentzy/ui/listening/lesson/lesson_view_model.dart';
import 'package:fluentzy/ui/speaking/record/record_screen.dart';
import 'package:fluentzy/ui/speaking/record/record_view_model.dart';
import 'package:fluentzy/ui/speaking/result/result_screen.dart';
import 'package:fluentzy/ui/speaking/result/result_view_model.dart';
import 'package:fluentzy/ui/scanner/result/result_view_model.dart';
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
    initialLocation: RoutePath.login,
    navigatorKey: _rootNavigatorKey,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainScreen(uri: state.uri, child: child);
        },
        routes: [
          GoRoute(
            path: RoutePath.home,
            builder: (context, state) => HomePage(),
          ),
          GoRoute(
            path: RoutePath.premium,
            builder:
                (context, state) => ChangeNotifierProvider(
                  create:
                      (context) =>
                          PremiumViewModel(context.read<IapRepository>()),
                  child: const PremiumPage(),
                ),
          ),
          GoRoute(
            path: RoutePath.chat,
            builder:
                (context, state) => ChangeNotifierProvider(
                  create:
                      (context) => ChatViewModel(context.read<AiRepository>()),
                  child: ChatScreen(),
                ),
          ),
          GoRoute(
            path: RoutePath.profile,
            builder:
                (context, state) => ChangeNotifierProvider(
                  create:
                      (context) =>
                          ProfileViewModel(context.read<AuthRepository>()),
                  child: const ProfilePage(),
                ),
          ),
        ],
      ),
      GoRoute(
        path: RoutePath.login,
        builder:
            (context, state) => ChangeNotifierProvider(
              create:
                  (context) => LoginViewModel(context.read<AuthRepository>()),
              child: LoginScreen(),
            ),
      ),
      GoRoute(
        path: RoutePath.register,
        builder:
            (context, state) => ChangeNotifierProvider(
              create:
                  (context) =>
                      RegisterViewModel(context.read<AuthRepository>()),
              child: RegisterScreen(),
            ),
      ),
      GoRoute(
        path: RoutePath.language,
        builder: (context, state) => LanguageScreen(),
      ),
      GoRoute(
        path: RoutePath.speakingRecordWithId,
        builder:
            (context, state) => ChangeNotifierProvider(
              create:
                  (context) => RecordViewModel(
                    context.read<SttRepository>(),
                    context.read<LessonRepository>(),
                    state.pathParameters[RoutePath.lessonId]!,
                  ),
              child: SpeakingRecordScreen(),
            ),
      ),
      GoRoute(
        path: RoutePath.speakingLesson,
        builder:
            (context, state) => ChangeNotifierProvider(
              create:
                  (context) =>
                      SpeakingLessonViewModel(context.read<LessonRepository>()),
              child: SpeakingLessonScreen(),
            ),
      ),
      GoRoute(
        path: RoutePath.speakingResult,
        builder:
            (context, state) => ChangeNotifierProvider(
              create:
                  (context) => SpeakingResultViewModel(
                    context.read<TtsRepository>(),
                    context.read<AiRepository>(),
                    context.read<LessonRepository>(),
                    state.extra as Map<String, dynamic>,
                  ),
              child: SpeakingResultScreen(),
            ),
      ),
      GoRoute(
        path: RoutePath.scannerOptions,
        builder:
            (context, state) => ChangeNotifierProvider(
              create:
                  (context) =>
                      OptionViewModel(context.read<ImagePickerService>()),
              child: ScannerOptionScreen(),
            ),
      ),
      GoRoute(
        path: RoutePath.scannerCamera,
        builder:
            (context, state) => ChangeNotifierProvider(
              create:
                  (context) => CameraViewModel(context.read<CameraService>()),
              child: ScannerCameraScreen(),
            ),
      ),
      GoRoute(
        path: RoutePath.scannerCrop,
        builder:
            (context, state) => ChangeNotifierProvider(
              create: (context) => CropViewModel(state.extra as XFile),
              child: ScannerCropScreen(),
            ),
      ),
      GoRoute(
        path: RoutePath.scannerResult,
        builder:
            (context, state) => ChangeNotifierProvider(
              create:
                  (context) => ScannerResultViewModel(
                    context.read<AiRepository>(),
                    context.read<DictionaryRepository>(),
                    context.read<TtsRepository>(),
                    state.extra as XFile,
                  ),
              child: ScannerResultScreen(),
            ),
      ),
      GoRoute(
        path: RoutePath.listeningLesson,
        builder:
            (context, state) => ChangeNotifierProvider(
              create:
                  (context) => ListeningLessonViewModel(
                    context.read<LessonRepository>(),
                  ),
              child: ListeningLessonScreen(),
            ),
      ),
      GoRoute(
        path: RoutePath.listeningPlayWithId,
        builder:
            (context, state) => ChangeNotifierProvider(
              create:
                  (context) => PlayViewModel(
                    context.read<LessonRepository>(),
                    context.read<AudioService>(),
                    state.pathParameters[RoutePath.lessonId]!,
                  ),
              child: PlayScreen(),
            ),
      ),
      GoRoute(
        path: RoutePath.flashCardList,
        builder:
            (context, state) => ChangeNotifierProvider(
              create:
                  (context) => FlashCardListViewModel(
                    context.read<FlashCardRepository>(),
                  ),
              child: FlashCardListScreen(),
            ),
      ),
      GoRoute(
        path: RoutePath.flashCardCreate,
        builder:
            (context, state) => ChangeNotifierProvider(
              create:
                  (context) => FlashCardEditViewModel(
                    context.read<FlashCardRepository>(),
                    context.read<AiRepository>(),
                    null,
                  ),
              child: FlashCardEditScreen(),
            ),
      ),
      GoRoute(
        path: RoutePath.flashCardEdit,
        builder:
            (context, state) => ChangeNotifierProvider(
              create:
                  (context) => FlashCardEditViewModel(
                    context.read<FlashCardRepository>(),
                    context.read<AiRepository>(),
                    state.extra as FlashCardSet,
                  ),
              child: FlashCardEditScreen(),
            ),
      ),
      GoRoute(
        path: RoutePath.flashCardLearn,
        builder:
            (context, state) => ChangeNotifierProvider(
              create:
                  (context) => FlashCardLearnViewModel(
                    context.read<FlashCardRepository>(),
                    state.extra as FlashCardSet,
                  ),
              child: const FlashCardLearnScreen(),
            ),
      ),
      GoRoute(
        path: RoutePath.quizLearnWithId,
        builder:
            (context, state) => ChangeNotifierProvider(
              create:
                  (context) => QuizLearnViewModel(
                    context.read<LessonRepository>(),
                    state.pathParameters[RoutePath.lessonId]!,
                  ),
              child: QuizLearnScreen(),
            ),
      ),
      GoRoute(
        path: RoutePath.translator,
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
        path: RoutePath.statistics,
        builder:
            (context, state) => ChangeNotifierProvider(
              create: (context) => StatisticsViewModel(),
              child: StatisticsScreen(),
            ),
      ),
    ],
  );
}
