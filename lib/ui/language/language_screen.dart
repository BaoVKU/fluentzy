import 'package:fluentzy/data/enums/support_language.dart';
import 'package:fluentzy/routing/paths.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/language/language_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LanguageViewModel>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(RoutePath.profile);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          surfaceTintColor: AppColors.onSecondary,
          backgroundColor: AppColors.background,
          leading: IconButton(
            onPressed: () => {context.go(RoutePath.profile)},
            icon: SvgPicture.asset("assets/back.svg"),
          ),
          actions: [
            IconButton(
              onPressed: () {
                viewModel.setLocale(
                  viewModel.selectedLanguage.languageCode.locale,
                );
                context.go(RoutePath.profile);
              },
              icon: Icon(Icons.check_rounded),
            ),
          ],
          title: Text(AppLocalizations.of(context)!.language),
        ),
        body: SafeArea(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              width: 480,
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.chooseDisplayLanguage,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  for (int i = 0; i < SupportLanguage.values.length; i++) ...[
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        viewModel.selectLanguage(SupportLanguage.values[i]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              viewModel.selectedLanguage ==
                                      SupportLanguage.values[i]
                                  ? AppColors.surfacePrimary
                                  : AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                viewModel.selectedLanguage ==
                                        SupportLanguage.values[i]
                                    ? AppColors.primary
                                    : AppColors.border,
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              SupportLanguage.values[i].flagAssetPath,
                              width: 40,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                SupportLanguage
                                    .values[i]
                                    .languageCode
                                    .nativeName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
