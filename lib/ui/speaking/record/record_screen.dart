import 'package:fluentzy/routing/paths.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/speaking/record/record_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SpeakingRecordScreen extends StatelessWidget {
  const SpeakingRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RecordViewModel>();
    if (viewModel.hasFinalResult && viewModel.listenedResult.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(
          RoutePath.speakingResult,
          extra: {'lesson': viewModel.lesson, 'said': viewModel.listenedResult},
        );
      });
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
            context.go(RoutePath.speakingLesson);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => {context.go(RoutePath.speakingLesson)},
            icon: SvgPicture.asset("assets/back.svg"),
          ),
          backgroundColor: AppColors.background,
          title: Text(AppLocalizations.of(context)!.speaking),
          titleSpacing: 0.0,
        ),
        body: SafeArea(
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      viewModel.lesson?.sentences[(viewModel.lesson!.lastDone +
                              1)] ??
                          AppLocalizations.of(context)!.cannotFindLesson,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 32),
                    SvgPicture.asset(
                      "assets/speaking.svg",
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 32),
                    Builder(
                      builder: (context) {
                        return viewModel.isListening
                            ? GestureDetector(
                              onTap: viewModel.stopRecording,
                              child: LottieBuilder.asset(
                                "assets/voice_recording.json",
                                width: 180,
                                height: 180,
                              ),
                            )
                            : IconButton.filled(
                              onPressed: viewModel.startRecording,
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  AppColors.primary,
                                ),
                              ),
                              icon: SvgPicture.asset(
                                "assets/microphone.svg",
                                width: 48,
                                height: 48,
                              ),
                            );
                      },
                    ),
                    SizedBox(height: 32),
                    if (viewModel.hasFinalResult &&
                        viewModel.listenedResult.isEmpty &&
                        !viewModel.isListening)
                      Text(
                        AppLocalizations.of(context)!.sayItAgain,
                        style: TextStyle(fontSize: 16, color: AppColors.error),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
