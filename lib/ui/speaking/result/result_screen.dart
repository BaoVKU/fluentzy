import 'package:fluentzy/data/models/speaking_response.dart';
import 'package:fluentzy/data/models/response_state.dart';
import 'package:fluentzy/routing/paths.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/speaking/result/result_view_model.dart';
import 'package:fluentzy/utils/color_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SpeakingResultScreen extends StatefulWidget {
  const SpeakingResultScreen({super.key});

  @override
  State<SpeakingResultScreen> createState() => _SpeakingResultScreenState();
}

class _SpeakingResultScreenState extends State<SpeakingResultScreen> {
  SpeakingResponse? _speakingResponse;
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SpeakingResultViewModel>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(RoutePath.home);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.go(RoutePath.home);
            },
            icon: SvgPicture.asset("assets/back.svg"),
          ),
          backgroundColor: AppColors.background,
          title: Text(AppLocalizations.of(context)!.result),
          titleSpacing: 0.0,
          actions: [
            IconButton(
              onPressed: () {
                viewModel.increaseLastDone(() {
                  if (viewModel.lastDone == viewModel.sentence.length - 1) {
                    context.go(RoutePath.speakingLesson);
                  } else {
                    context.go(
                      "${RoutePath.speakingRecord}/${viewModel.lessonId}",
                    );
                  }
                });
              },
              icon: SvgPicture.asset("assets/next.svg"),
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    switch (viewModel.responseState) {
                      case Initial():
                        return CircularProgressIndicator(
                          color: AppColors.primary,
                        );
                      case Loading():
                        return CircularProgressIndicator(
                          color: AppColors.primary,
                        );
                      case Success():
                        {
                          final response =
                              (viewModel.responseState as Success).data;
                          if (_speakingResponse == null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                _speakingResponse = response;
                              });
                            });
                          }
                          return Text(
                            "${_speakingResponse?.rate}%",
                            style: TextStyle(
                              fontSize: 96,
                              fontWeight: FontWeight.bold,
                              color: ColorPicker.getColorForAccuracy(
                                _speakingResponse?.rate,
                              ),
                            ),
                          );
                        }
                      case Error():
                        {
                          final error =
                              (viewModel.responseState as Error).message;
                          return Text(
                            error,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.error,
                            ),
                          );
                        }
                    }
                  },
                ),
                SizedBox(height: 24),
                Text(
                  viewModel.sentence,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      viewModel.responseState is Success &&
                              _speakingResponse != null
                          ? _speakingResponse!.ipa
                          : '',
                      style: TextStyle(fontSize: 20),
                    ),
                    IconButton(
                      onPressed: () {
                        if (viewModel.isSpeaking) {
                          viewModel.stopSpeaker();
                        } else {
                          viewModel.playSpeaker(text: viewModel.sentence);
                        }
                      },
                      icon: SvgPicture.asset(
                        "assets/speaker.svg",
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                if (viewModel.responseState is Success &&
                    _speakingResponse != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      _speakingResponse!.feedback,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                SizedBox(height: 32),
                IconButton.filled(
                  padding: EdgeInsets.all(16),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      AppColors.primary,
                    ),
                  ),
                  onPressed: () {
                    context.go(
                      "${RoutePath.speakingRecord}/${viewModel.lessonId}",
                    );
                  },
                  icon: SvgPicture.asset(
                    "assets/retry.svg",
                    width: 48,
                    height: 48,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
