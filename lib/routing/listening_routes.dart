import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:fluentzy/data/services/audio_service.dart';
import 'package:fluentzy/routing/app_route_path.dart';
import 'package:fluentzy/ui/listening/lesson/lesson_screen.dart';
import 'package:fluentzy/ui/listening/lesson/lesson_view_model.dart';
import 'package:fluentzy/ui/listening/play/play_screen.dart';
import 'package:fluentzy/ui/listening/play/play_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final listeningRoutes = [
  GoRoute(
    path: AppRoutePath.listeningLesson,
    builder:
        (context, state) => ChangeNotifierProvider(
          create:
              (context) =>
                  ListeningLessonViewModel(context.read<LessonRepository>()),
          child: ListeningLessonScreen(),
        ),
  ),
  GoRoute(
    path: AppRoutePath.listeningPlayWithId,
    builder:
        (context, state) => ChangeNotifierProvider(
          create:
              (context) => PlayViewModel(
                context.read<LessonRepository>(),
                context.read<AudioService>(),
                state.pathParameters[AppRoutePath.lessonId]!,
              ),
          child: PlayScreen(),
        ),
  ),
];
