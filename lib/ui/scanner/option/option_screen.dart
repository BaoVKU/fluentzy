import 'package:fluentzy/routing/paths.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/scanner/option/option_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScannerOptionScreen extends StatelessWidget {
  const ScannerOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OptionViewModel>();

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
          surfaceTintColor: AppColors.onSecondary,
          backgroundColor: AppColors.background,
          leading: IconButton(
            onPressed: () => {context.go(RoutePath.home)},
            icon: SvgPicture.asset("assets/back.svg"),
          ),
          titleSpacing: 0.0,
          title: Text(AppLocalizations.of(context)!.scanOptions),
        ),
        body: Builder(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (viewModel.image != null && viewModel.imageMimeType != null) {
                if (viewModel.imageMimeType == 'image/jpeg' ||
                    viewModel.imageMimeType == 'image/png') {
                  context.go(RoutePath.scannerCrop, extra: viewModel.image);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.pleaseSelectJpgPng,
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            });
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 16,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        viewModel.pickImage();
                      },
                      child: Container(
                        width: 400,
                        height: 96,
                        decoration: BoxDecoration(
                          color: AppColors.imageOptionBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          spacing: 16,
                          children: [
                            const SizedBox(width: 8),
                            SvgPicture.asset(
                              "assets/gallery.svg",
                              width: 40,
                              height: 40,
                            ),
                            Text(
                              AppLocalizations.of(context)!.chooseImage,
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.imageOptionForeground,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!kIsWeb)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: () {
                          context.go(RoutePath.scannerCamera);
                        },
                        child: Container(
                          height: 96,
                          decoration: BoxDecoration(
                            color: AppColors.cameraOptionBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            spacing: 16,
                            children: [
                              const SizedBox(width: 8),
                              SvgPicture.asset(
                                "assets/lens.svg",
                                width: 40,
                                height: 40,
                              ),
                              Text(
                                AppLocalizations.of(context)!.usingCamera,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.cameraOptionForeground,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
