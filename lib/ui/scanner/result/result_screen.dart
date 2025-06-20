import 'dart:io';

import 'package:fluentzy/data/models/dictionary_entry.dart';
import 'package:fluentzy/data/models/response_state.dart';
import 'package:fluentzy/extensions/string_ext.dart';
import 'package:fluentzy/routing/app_route_path.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/scanner/result/result_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScannerResultScreen extends StatelessWidget {
  const ScannerResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScannerResultViewModel>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(AppRoutePath.scannerOptions);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          surfaceTintColor: AppColors.onSecondary,
          backgroundColor: AppColors.background,
          title: Text(AppLocalizations.of(context)!.result),
          leading: IconButton(
            onPressed: () => {context.go(AppRoutePath.scannerOptions)},
            icon: SvgPicture.asset("assets/back.svg"),
          ),
          titleSpacing: 0.0,
        ),
        body: SafeArea(
          child: Center(
            child: Container(
              width: 800,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Builder(
                        builder: (context) {
                          if (kIsWeb) {
                            return SizedBox(
                              height: 540,
                              width: 960,
                              child: Image.network(
                                viewModel.image.path,
                                fit: BoxFit.cover,
                              ),
                            );
                          } else {
                            return Image.file(
                              File(viewModel.image.path),
                              fit: BoxFit.cover,
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Builder(
                      builder: (context) {
                        switch (viewModel.responseState) {
                          case Success():
                            {
                              final data =
                                  (viewModel.responseState as Success).data
                                      as DictionaryEntry;
                              final meanings = data.meanings;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.word.capitalize(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        data.phonetic,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'NotoSans',
                                        ),
                                      ),
                                      SizedBox(width: 8.0),
                                      GestureDetector(
                                        onTap:
                                            () => {
                                              viewModel.speakOutLoud(
                                                text: data.word,
                                              ),
                                            },
                                        child: SvgPicture.asset(
                                          "assets/speaker.svg",
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  for (int i = 0; i < meanings.length; i++) ...[
                                    SizedBox(height: 32.0),
                                    Text(
                                      "(${meanings[i].partOfSpeech})",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    for (
                                      int j = 0;
                                      j < meanings[i].definitions.length;
                                      j++
                                    ) ...[
                                      Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.dictionaryWordDefinition(
                                          meanings[i].definitions[j].definition,
                                        ),
                                      ),
                                      if (meanings[i].definitions[j].example !=
                                          null) ...[
                                        SizedBox(height: 4.0),
                                        Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.dictionaryWordSample(
                                            meanings[i].definitions[j].example!,
                                          ),
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: AppColors.onSecondary,
                                          ),
                                        ),
                                      ],
                                      SizedBox(height: 24.0),
                                    ],
                                  ],
                                ],
                              );
                            }
                          case Error():
                            {
                              return Text(
                                AppLocalizations.of(
                                  context,
                                )!.objectDetectionError,
                                style: TextStyle(color: AppColors.error),
                              );
                            }
                          default:
                            {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              );
                            }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
