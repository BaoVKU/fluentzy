import 'package:fluentzy/routing/app_route_path.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/statistics/statistics_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StatisticsViewModel viewModel = context.watch<StatisticsViewModel>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(AppRoutePath.home);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          surfaceTintColor: AppColors.onSecondary,
          backgroundColor: AppColors.background,
          leading: IconButton(
            onPressed: () => {context.go(AppRoutePath.home)},
            icon: SvgPicture.asset("assets/back.svg"),
          ),
          title: Text(AppLocalizations.of(context)!.statistics),
          titleSpacing: 0.0,
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              if (viewModel.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              return Center(
                child: Container(
                  width: 480,
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            SvgPicture.asset(
                              "assets/award.svg",
                              colorFilter: ColorFilter.mode(
                                viewModel.getLevelBadge(60.0).$2,
                                BlendMode.srcIn,
                              ),
                              width: 160,
                              height: 160,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: Text(
                                viewModel.getLevelBadge(60.0).$1,
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.background,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 160,
                                  height: 160,
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween<double>(
                                      begin: 0.0,
                                      end:
                                          viewModel.countLearnedWords() /
                                          viewModel.countTotalWords(),
                                    ),
                                    duration: const Duration(seconds: 1),
                                    builder: (context, value, child) {
                                      return CircularProgressIndicator(
                                        value: value,
                                        backgroundColor: AppColors.secondary,
                                        strokeWidth: 8,
                                        color: AppColors.flashCardBackground,
                                      );
                                    },
                                  ),
                                ),
                                TweenAnimationBuilder<int>(
                                  tween: IntTween(
                                    begin: 0,
                                    end: viewModel.countLearnedWords(),
                                  ),
                                  duration: const Duration(seconds: 1),
                                  builder: (context, value, child) {
                                    return Text(
                                      "$value\nWords",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.flashCardBackground,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 160,
                                  height: 160,
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween<double>(
                                      begin: 0.0,
                                      end:
                                          viewModel
                                              .countCorrectedQuizAnswers() /
                                          viewModel.countTotalQuizAnswers(),
                                    ),
                                    duration: const Duration(seconds: 1),
                                    builder: (context, value, child) {
                                      return CircularProgressIndicator(
                                        value: value,
                                        backgroundColor: AppColors.secondary,
                                        strokeWidth: 8,
                                        color: AppColors.quizBackground,
                                      );
                                    },
                                  ),
                                ),
                                TweenAnimationBuilder<int>(
                                  tween: IntTween(
                                    begin: 0,
                                    end: viewModel.countCorrectedQuizAnswers(),
                                  ),
                                  duration: const Duration(seconds: 1),
                                  builder: (context, value, child) {
                                    return Text(
                                      textAlign: TextAlign.center,
                                      "$value%\nAccuracy",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.quizBackground,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.speaking,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TweenAnimationBuilder<int>(
                              tween: IntTween(
                                begin: 0,
                                end: viewModel.countCompletedSpeakingLessons(),
                              ),
                              duration: const Duration(seconds: 1),
                              builder: (context, value, child) {
                                return Text(
                                  "$value/${viewModel.speakingLessons.length}",
                                  style: TextStyle(fontSize: 16),
                                );
                              },
                            ),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: 0.0,
                              end:
                                  viewModel.countCompletedSpeakingLessons() /
                                  viewModel.speakingLessons.length,
                            ),
                            duration: const Duration(seconds: 1),
                            builder: (context, value, child) {
                              return LinearProgressIndicator(
                                value: value,
                                backgroundColor: AppColors.secondary,
                                minHeight: 8,
                                color: AppColors.speakingBackground,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.flashCard,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TweenAnimationBuilder<int>(
                              tween: IntTween(
                                begin: 0,
                                end: viewModel.countCompletedFlashCardSets(),
                              ),
                              duration: const Duration(seconds: 1),
                              builder: (context, value, child) {
                                return Text(
                                  "$value/${viewModel.flashCardSets.length}",
                                  style: TextStyle(fontSize: 16),
                                );
                              },
                            ),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: 0.0,
                              end:
                                  viewModel.countCompletedFlashCardSets() /
                                  viewModel.flashCardSets.length,
                            ),
                            duration: const Duration(seconds: 1),
                            builder: (context, value, child) {
                              return LinearProgressIndicator(
                                value: value,
                                backgroundColor: AppColors.secondary,
                                minHeight: 8,
                                color: AppColors.flashCardBackground,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.quiz,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TweenAnimationBuilder<int>(
                              tween: IntTween(
                                begin: 0,
                                end: viewModel.countCompletedQuizLessons(),
                              ),
                              duration: const Duration(seconds: 1),
                              builder: (context, value, child) {
                                return Text(
                                  "$value/${viewModel.quizLessons.length}",
                                  style: TextStyle(fontSize: 16),
                                );
                              },
                            ),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: 0.0,
                              end:
                                  viewModel.countCompletedQuizLessons() /
                                  viewModel.quizLessons.length,
                            ),
                            duration: const Duration(seconds: 1),
                            builder: (context, value, child) {
                              return LinearProgressIndicator(
                                value: value,
                                backgroundColor: AppColors.secondary,
                                minHeight: 8,
                                color: AppColors.quizBackground,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 32),
                        Text(
                          textAlign: TextAlign.center,
                          "\"${viewModel.todayTipQuote}\"",
                          style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            color: AppColors.onSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
