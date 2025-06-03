import 'dart:async';
import 'dart:ui';
import 'package:fluentzy/ui/translator/translator_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:language_code/language_code.dart';
import 'package:lottie/lottie.dart';

class TranslationBlock extends StatefulWidget {
  final TranslatorViewModel viewModel;
  final TextEditingController controller;
  final bool isResultView;
  final Function onRequestClear;
  final Function? onInputChanged;

  const TranslationBlock({
    super.key,
    required this.viewModel,
    required this.controller,
    required this.isResultView,
    required this.onRequestClear,
    this.onInputChanged,
  });

  @override
  State<TranslationBlock> createState() => _TranslationBlockState();
}

class _TranslationBlockState extends State<TranslationBlock> {
  Timer? _debounce;
  bool isShowingBottomSheet = false;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.viewModel.hasFinalResult &&
        widget.viewModel.listenedResult.isNotEmpty &&
        isShowingBottomSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pop();
      });
    }
    if (widget.viewModel.isTimeout) {
      isShowingBottomSheet = false;
      widget.viewModel.resetTimeout();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.sayItAgain),
            duration: const Duration(seconds: 2),
          ),
        );
      });
    }
    return Container(
      height: kIsWeb ? 360 : null,
      width: 680,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border, width: 1.0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Row(
              children: [
                Text(
                  LanguageCodes.fromCode(
                    widget.isResultView
                        ? widget.viewModel.targetLangCode
                        : widget.viewModel.sourceLangCode,
                  ).nativeName,
                  style: TextStyle(
                    backgroundColor: AppColors.background,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (!widget.isResultView && !kIsWeb)
                  IconButton(
                    onPressed: () {
                      if (widget.controller.text.isNotEmpty) {
                        widget.onRequestClear();
                        setState(() {});
                      }
                      _showVoiceRecordSheet(context: context);
                      isShowingBottomSheet = true;
                    },
                    icon: Icon(Icons.mic_rounded),
                  ),
                IconButton(
                  onPressed: () {
                    if (widget.controller.text.isEmpty) {
                      return;
                    }
                    widget.viewModel.speakOutLoud(
                      text: widget.controller.text,
                      langCode:
                          widget.isResultView
                              ? widget.viewModel.targetLangCode
                              : widget.viewModel.sourceLangCode,
                    );
                  },
                  icon: Icon(Icons.volume_up_rounded),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.border, thickness: 1.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isResultView && widget.viewModel.isTranslating)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: LottieBuilder.asset("assets/typing.json", width: 32),
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right: widget.isResultView ? 16.0 : 0.0,
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                        selectionColor: AppColors.primary.withAlpha(
                          (0.2 * 255).toInt(),
                        ),
                        cursorColor: AppColors.primary,
                      ),
                    ),
                    child: TextField(
                      enabled: !widget.isResultView,
                      style: TextStyle(color: Colors.black),
                      controller: widget.controller,
                      onChanged: (text) {
                        if (text.isEmpty) {
                          widget.onRequestClear();
                        }
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce = Timer(const Duration(seconds: 2), () {
                          if (widget.isResultView ||
                              widget.controller.text.isEmpty) {
                            return;
                          }
                          widget.onInputChanged?.call();
                        });
                        setState(() {});
                      },
                      minLines: 8,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      selectionHeightStyle: BoxHeightStyle.tight,
                      selectionWidthStyle: BoxWidthStyle.tight,
                      selectionControls: materialTextSelectionControls,
                      decoration: InputDecoration(
                        hintText:
                            widget.isResultView
                                ? null
                                : AppLocalizations.of(context)!.pleaseEnterText,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              if (!widget.isResultView && widget.controller.text.isNotEmpty)
                IconButton(
                  onPressed: () {
                    widget.onRequestClear();
                    setState(() {});
                  },
                  icon: Icon(Icons.close_rounded),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showVoiceRecordSheet({required BuildContext context}) {
    showModalBottomSheet(
      backgroundColor: AppColors.background,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 480,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 32,
                left: 0,
                right: 0,
                top: 16,
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: StreamBuilder<String>(
                        stream: widget.viewModel.resultStream,
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data ?? '',
                            style: TextStyle(fontSize: 28),
                          );
                        },
                      ),
                    ),
                  ),
                  if (widget.viewModel.isListening)
                    Expanded(
                      child: LottieBuilder.asset(
                        "assets/voice_recording_2.json",
                        height: 180,
                      ),
                    ),
                  if (!widget.viewModel.isListening)
                    Expanded(
                      child: Divider(color: AppColors.primary, thickness: 1.0),
                    ),
                  IconButton.filled(
                    onPressed: () {
                      if (widget.viewModel.isListening) {
                        widget.viewModel.stopRecording();
                      } else {
                        widget.viewModel.startRecording();
                      }
                      setModalState(() {});
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        AppColors.primary,
                      ),
                    ),
                    icon: Icon(
                      widget.viewModel.isListening
                          ? Icons.stop_rounded
                          : Icons.mic_rounded,
                      size: 48,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      isShowingBottomSheet = false;
      if (widget.viewModel.isListening) {
        widget.viewModel.stopRecording();
      }
    });
  }
}
