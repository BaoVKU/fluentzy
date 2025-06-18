import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:fluentzy/routing/app_route_path.dart';
import 'package:fluentzy/ui/quiz/learn/learn_screen.dart';
import 'package:fluentzy/ui/quiz/learn/learn_view_model.dart';
import 'package:fluentzy/ui/quiz/lesson/lesson_screen.dart';
import 'package:fluentzy/ui/quiz/lesson/lesson_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final quizRoutes = [
  GoRoute(
    path: AppRoutePath.quizLesson,
    builder:
        (context, state) => ChangeNotifierProvider(
          create:
              (context) =>
                  QuizLessonViewModel(context.read<LessonRepository>()),
          child: QuizLessonScreen(),
        ),
  ),
  GoRoute(
    path: AppRoutePath.quizLearnWithId,
    builder:
        (context, state) => ChangeNotifierProvider(
          create:
              (context) => QuizLearnViewModel(
                context.read<LessonRepository>(),
                state.pathParameters[AppRoutePath.lessonId]!,
              ),
          child: QuizLearnScreen(),
        ),
  ),
];
