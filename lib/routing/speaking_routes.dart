import 'package:fluentzy/data/repositories/ai_repository.dart';
import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:fluentzy/data/repositories/stt_repository.dart';
import 'package:fluentzy/data/repositories/tts_repository.dart';
import 'package:fluentzy/routing/app_route_path.dart';
import 'package:fluentzy/ui/speaking/lesson/lesson_screen.dart';
import 'package:fluentzy/ui/speaking/lesson/lesson_view_model.dart';
import 'package:fluentzy/ui/speaking/record/record_screen.dart';
import 'package:fluentzy/ui/speaking/record/record_view_model.dart';
import 'package:fluentzy/ui/speaking/result/result_screen.dart';
import 'package:fluentzy/ui/speaking/result/result_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final speakingRoutes = [
  GoRoute(
    path: AppRoutePath.speakingRecordWithId,
    builder:
        (context, state) => ChangeNotifierProvider(
          create:
              (context) => RecordViewModel(
                context.read<SttRepository>(),
                context.read<LessonRepository>(),
                state.pathParameters[AppRoutePath.lessonId]!,
              ),
          child: SpeakingRecordScreen(),
        ),
  ),
  GoRoute(
    path: AppRoutePath.speakingLesson,
    builder:
        (context, state) => ChangeNotifierProvider(
          create:
              (context) =>
                  SpeakingLessonViewModel(context.read<LessonRepository>()),
          child: SpeakingLessonScreen(),
        ),
  ),
  GoRoute(
    path: AppRoutePath.speakingResult,
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
];
