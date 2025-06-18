import 'package:fluentzy/routing/app_route_path.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/translator/translation_block.dart';
import 'package:fluentzy/ui/translator/translator_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:provider/provider.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TextEditingController _translatingController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();

  @override
  void dispose() {
    _translatingController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TranslatorViewModel viewModel = context.watch<TranslatorViewModel>();
    if (viewModel.hasFinalResult &&
        viewModel.listenedResult.isNotEmpty &&
        _resultController.text.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _translatingController.text = viewModel.listenedResult;
        viewModel.translate(_translatingController.text).then((result) {
          _resultController.text = result;
        });
      });
    }
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
          title: Text(AppLocalizations.of(context)!.translator),
          titleSpacing: 0.0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Builder(
              builder: (context) {
                if (kIsWeb) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TranslationBlock(
                        viewModel: viewModel,
                        controller: _translatingController,
                        isResultView: false,
                        onRequestClear: () {
                          _translatingController.clear();
                          _resultController.clear();
                          viewModel.reset();
                        },
                        onInputChanged: () {
                          viewModel.translate(_translatingController.text).then(
                            (result) {
                              _resultController.text = result;
                            },
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          top: 8.0,
                        ),
                        child: IconButton(
                          onPressed: viewModel.swapLanguages,
                          icon: Icon(Icons.compare_arrows_rounded, size: 32),
                        ),
                      ),
                      TranslationBlock(
                        viewModel: viewModel,
                        controller: _resultController,
                        isResultView: true,
                        onRequestClear: () {
                          _translatingController.clear();
                          _resultController.clear();
                          viewModel.reset();
                        },
                      ),
                    ],
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      TranslationBlock(
                        viewModel: viewModel,
                        controller: _translatingController,
                        isResultView: false,
                        onRequestClear: () {
                          _translatingController.clear();
                          _resultController.clear();
                          viewModel.reset();
                        },
                        onInputChanged: () {
                          viewModel.translate(_translatingController.text).then(
                            (result) {
                              _resultController.text = result;
                            },
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: IconButton(
                          onPressed: viewModel.swapLanguages,
                          icon: Icon(Icons.compare_arrows_rounded, size: 32),
                        ),
                      ),
                      TranslationBlock(
                        viewModel: viewModel,
                        controller: _resultController,
                        isResultView: true,
                        onRequestClear: () {
                          _translatingController.clear();
                          _resultController.clear();
                          viewModel.reset();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
