import 'package:camera/camera.dart';
import 'package:fluentzy/data/repositories/ai_repository.dart';
import 'package:fluentzy/data/repositories/auth_repository.dart';
import 'package:fluentzy/data/repositories/dictionary_repository.dart';
import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:fluentzy/data/repositories/stt_repository.dart';
import 'package:fluentzy/data/repositories/tts_repository.dart';
import 'package:fluentzy/data/services/audio_service.dart';
import 'package:fluentzy/data/services/camera_service.dart';
import 'package:fluentzy/data/services/image_picker_service.dart';
import 'package:fluentzy/routing/paths.dart';
import 'package:fluentzy/ui/listening/lesson_screen.dart';
import 'package:fluentzy/ui/listening/play_screen.dart';
import 'package:fluentzy/ui/listening/play_view_model.dart';
import 'package:fluentzy/ui/login/login_screen.dart';
import 'package:fluentzy/ui/login/login_view_model.dart';
import 'package:fluentzy/ui/main/main_screen.dart';
import 'package:fluentzy/ui/scanner/camera_screen.dart';
import 'package:fluentzy/ui/scanner/camera_view_model.dart';
import 'package:fluentzy/ui/scanner/crop_screen.dart';
import 'package:fluentzy/ui/scanner/crop_view_model.dart';
import 'package:fluentzy/ui/scanner/option_screen.dart';
import 'package:fluentzy/ui/scanner/option_view_model.dart';
import 'package:fluentzy/ui/scanner/result_screen.dart';
import 'package:fluentzy/ui/speaking/lesson_screen.dart';
import 'package:fluentzy/ui/speaking/lesson_view_model.dart';
import 'package:fluentzy/ui/listening/lesson_view_model.dart';
import 'package:fluentzy/ui/speaking/record_screen.dart';
import 'package:fluentzy/ui/speaking/record_view_model.dart';
import 'package:fluentzy/ui/speaking/result_screen.dart';
import 'package:fluentzy/ui/speaking/result_view_model.dart';
import 'package:fluentzy/ui/scanner/result_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RoutePath.login,
    routes: [
      GoRoute(path: RoutePath.main, builder: (context, state) => MainScreen()),
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
                  (context) => SpeakingLessonViewModel(
                    context.read<LessonRepository>(),
                  ),
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
                  (context) =>
                      ListeningLessonViewModel(context.read<LessonRepository>()),
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
    ],
  );
}
