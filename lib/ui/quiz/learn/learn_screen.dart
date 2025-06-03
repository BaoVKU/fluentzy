import 'package:fluentzy/routing/paths.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/quiz/learn/learn_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class QuizLearnScreen extends StatelessWidget {
  const QuizLearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QuizLearnViewModel viewModel = context.watch<QuizLearnViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        surfaceTintColor: AppColors.onSecondary,
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () => {context.go(RoutePath.quizLesson)},
          icon: SvgPicture.asset("assets/back.svg"),
        ),
        titleSpacing: 0.0,
        title: Text(
          viewModel.lesson?.name ?? AppLocalizations.of(context)!.quiz,
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (viewModel.selectedAnswerIndex == -1) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.selectAnswerFirst,
                    ),
                    backgroundColor: AppColors.error,
                  ),
                );
                return;
              }

              if (viewModel.isResultShown) {
                if (viewModel.currentQuestionIndex ==
                    viewModel.lesson!.questions.length - 1) {
                  viewModel.saveProgress();
                  context.go(RoutePath.quizLesson);
                  return;
                }
                viewModel.nextQuestion();
              } else {
                viewModel.showResult();
              }
            },
            icon:
                (viewModel.lesson != null &&
                        viewModel.isResultShown &&
                        viewModel.currentQuestionIndex ==
                            viewModel.lesson!.questions.length - 1)
                    ? Icon(Icons.check_rounded)
                    : SvgPicture.asset("assets/next.svg"),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 800,
            padding: const EdgeInsets.all(16.0),
            child: Builder(
              builder: (context) {
                if (viewModel.lesson == null) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value:
                            (viewModel.currentQuestionIndex + 1) /
                            viewModel.lesson!.questions.length,
                        backgroundColor: AppColors.secondary,
                        minHeight: 8,
                        color:
                            viewModel.isResultShown
                                ? (viewModel.isAnswerCorrect
                                    ? AppColors.success
                                    : AppColors.error)
                                : AppColors.primary,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Builder(
                          builder: (context) {
                            if (viewModel.isResultShown) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (viewModel.isAnswerCorrect) ...[
                                    Icon(
                                      Icons.check_circle_rounded,
                                      size: 160,
                                      color: AppColors.success,
                                    ),
                                    Text(
                                      "Correct!",
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: AppColors.success,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ] else ...[
                                    Icon(
                                      Icons.error,
                                      size: 160,
                                      color: AppColors.error,
                                    ),
                                    Text(
                                      "Incorrect!",
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: AppColors.error,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            }
                            return Text(
                              viewModel
                                  .lesson!
                                  .questions[viewModel.currentQuestionIndex]
                                  .question,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.count(
                        childAspectRatio: 5,
                        crossAxisCount: kIsWeb ? 2 : 1,
                        shrinkWrap: true,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          for (
                            int i = 0;
                            i <
                                viewModel
                                    .lesson!
                                    .questions[viewModel.currentQuestionIndex]
                                    .answers
                                    .length;
                            i++
                          )
                            GestureDetector(
                              onTap: () {
                                if (viewModel.isResultShown) {
                                  return;
                                }
                                viewModel.selectAnswer(i);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color:
                                        viewModel
                                            .answerButtonStates[i]['borderColor'],
                                    width:
                                        (viewModel.answerButtonStates[i]['borderWidth']
                                                as num)
                                            .toDouble(),
                                  ),
                                  color:
                                      viewModel
                                          .answerButtonStates[i]['backgroundColor'],
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.secondary,
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                height: 52,
                                child: Center(
                                  child: Text(
                                    viewModel
                                        .lesson!
                                        .questions[viewModel
                                            .currentQuestionIndex]
                                        .answers[i],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
