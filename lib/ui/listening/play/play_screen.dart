import 'package:fluentzy/data/models/transcript_line.dart';
import 'package:fluentzy/routing/paths.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/listening/play/play_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:language_code/language_code.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PlayViewModel viewModel = context.watch<PlayViewModel>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(RoutePath.listeningLesson);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => {context.go(RoutePath.listeningLesson)},
            icon: SvgPicture.asset("assets/back.svg"),
          ),
          backgroundColor: AppColors.background,
          title: Text(AppLocalizations.of(context)!.listening),
          titleSpacing: 0.0,
          actions: [
            if (viewModel.isTranscriptEnabled)
              IconButton(
                onPressed: () {
                  viewModel.toggleDualLanguage();
                },
                icon: Icon(
                  Icons.splitscreen_rounded,
                  color:
                      viewModel.isDualLanguageEnabled
                          ? AppColors.primary
                          : AppColors.onSecondary,
                ),
              ),
            IconButton(
              onPressed: () {
                viewModel.toggleTranscript();
              },
              icon: Icon(
                Icons.subtitles,
                color:
                    viewModel.isTranscriptEnabled
                        ? AppColors.primary
                        : AppColors.onSecondary,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              if (viewModel.lesson == null) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              return SizedBox(
                width: 800,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.lesson!.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      StreamBuilder<PlayerState>(
                        stream: viewModel.audioPlayer.playerStateStream,
                        builder: (context, snapshot) {
                          final state = snapshot.data;
                          final isPlaying = state?.playing ?? false;
              
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.replay_5, size: 36),
                                onPressed: () async {
                                  final current =
                                      viewModel.audioPlayer.position;
                                  viewModel.audioPlayer.seek(
                                    current - const Duration(seconds: 5),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                  size: 64,
                                ),
                                onPressed: () {
                                  isPlaying
                                      ? viewModel.audioPlayer.pause()
                                      : viewModel.audioPlayer.play();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.forward_5, size: 36),
                                onPressed: () async {
                                  final current =
                                      viewModel.audioPlayer.position;
                                  viewModel.audioPlayer.seek(
                                    current + const Duration(seconds: 5),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
              
                      const SizedBox(height: 8),
              
                      /// Position Slider with time indicators
                      StreamBuilder<Duration>(
                        stream: viewModel.audioPlayer.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data ?? Duration.zero;
                          final total =
                              viewModel.audioPlayer.duration ??
                              Duration(seconds: 1);
              
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      formatDuration(position.inSeconds),
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      formatDuration(total.inSeconds),
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Slider(
                                activeColor: AppColors.primary,
                                inactiveColor: AppColors.surfacePrimary,
                                value:
                                    position.inSeconds
                                        .clamp(0, total.inSeconds)
                                        .toDouble(),
                                max: total.inSeconds.toDouble(),
                                onChanged: (value) {
                                  viewModel.audioPlayer.seek(
                                    Duration(seconds: value.toInt()),
                                  );
                                },
                              )
                            ],
                          );
                        },
                      ),
              
                      const SizedBox(height: 8),
              
                      /// Volume Control
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.volume,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          StreamBuilder<double>(
                            stream: viewModel.audioPlayer.volumeStream,
                            builder: (context, snapshot) {
                              final volume = snapshot.data ?? 1.0;
                              return Slider(
                                activeColor: AppColors.primary,
                                inactiveColor: AppColors.surfacePrimary,
                                value: volume,
                                min: 0,
                                max: 1,
                                divisions: 10,
                                onChanged:
                                    (value) => viewModel.audioPlayer
                                        .setVolume(value),
                              );
                            },
                          ),
                        ],
                      ),
              
                      const SizedBox(height: 8),
              
                      /// Speed Control
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.speed,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          StreamBuilder<double>(
                            stream: viewModel.audioPlayer.speedStream,
                            builder: (context, snapshot) {
                              final speed = snapshot.data ?? 1.0;
                              return Slider(
                                activeColor: AppColors.primary,
                                inactiveColor: AppColors.surfacePrimary,
                                value: speed,
                                min: 0.5,
                                max: 2.0,
                                divisions: 6,
                                label: "${speed.toStringAsFixed(1)}x",
                                onChanged:
                                    (value) =>
                                        viewModel.audioPlayer.setSpeed(value),
                              );
                            },
                          ),
                        ],
                      ),
              
                      if (viewModel.isTranscriptEnabled)
                        StreamBuilder<Duration>(
                          stream: viewModel.audioPlayer.positionStream,
                          builder: (context, snapshot) {
                            final position = snapshot.data ?? Duration.zero;
                            final currentLine = viewModel.lesson!.transcripts
                                .lastWhere(
                                  (line) => line.start <= position,
                                  orElse:
                                      () => TranscriptLine(
                                        start: Duration.zero,
                                        en: '',
                                        vi: '',
                                      ),
                                );
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(child: Divider()),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.transcript,
                                          style: TextStyle(
                                            color: AppColors.onSecondary,
                                          ),
                                        ),
                                      ),
                                      Expanded(child: Divider()),
                                    ],
                                  ),
                                ),
              
                                const SizedBox(height: 8),
              
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    currentLine.en,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                if (viewModel.isDualLanguageEnabled) ...[
                                  const SizedBox(height: 32),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Text(
                                      currentLine.vi,
                                    textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    final formattedHours = hours > 0 ? '$hours:' : '';
    final formattedMinutes = minutes.toString().padLeft(2, '0');
    final formattedSeconds = secs.toString().padLeft(2, '0');
    return '$formattedHours$formattedMinutes:$formattedSeconds';
  }
}
