import 'package:fluentzy/extensions/int_ext.dart';
import 'package:fluentzy/routing/app_route_path.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/quiz/lesson/lesson_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuizLessonScreen extends StatelessWidget {
  const QuizLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QuizLessonViewModel viewModel = context.watch<QuizLessonViewModel>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(AppRoutePath.home);
        }
      },
      child: LayoutBuilder(
        builder: (context, constraint) {
          final isMediumScreen =
              constraint.maxWidth > 600 && constraint.maxWidth < 840;
          final isMediumHighScreen =
              constraint.maxWidth >= 840 && constraint.maxWidth <= 1200;
          final isLargeScreen = constraint.maxWidth > 1200;
          int columnCount = 1;
          if (isLargeScreen) {
            columnCount = 4;
          } else if (isMediumHighScreen) {
            columnCount = 3;
          } else if (isMediumScreen) {
            columnCount = 2;
          }
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              surfaceTintColor: AppColors.onSecondary,
              backgroundColor: AppColors.background,
              leading: IconButton(
                onPressed: () => {context.go(AppRoutePath.home)},
                icon: SvgPicture.asset("assets/back.svg"),
              ),
              titleSpacing: 0.0,
              title: Text(AppLocalizations.of(context)!.lessons),
            ),
            body: SafeArea(
              child: Builder(
                builder: (context) {
                  if (viewModel.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnCount,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 3.5, // Width/Height ratio
                    ),
                    itemCount: viewModel.lessons.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap:
                            () => {
                              context.go(
                                "${AppRoutePath.quizLearn}/${viewModel.lessons[index].id}",
                              ),
                            },
                        child: Card(
                          color: AppColors.surfacePrimary,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.primary,
                                      width: 3,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      (index + 1).toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Text(
                                      viewModel.lessons[index].name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  "${viewModel.getAccuracyPercent(viewModel.lessons[index].id)}%",
                                  style: TextStyle(
                                    color:
                                        viewModel
                                            .getAccuracyPercent(
                                              viewModel.lessons[index].id,
                                            )
                                            .getAccuracyColor(),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
