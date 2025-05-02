import 'package:fluentzy/routing/paths.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/scanner/option_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

class ScannerOptionScreen extends StatelessWidget {
  const ScannerOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OptionViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () => {context.go(RoutePath.main)},
          icon: SvgPicture.asset("assets/back.svg"),
        ),
        titleSpacing: 0.0,
        title: const Text('Scan Options'),
      ),
      body: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (viewModel.image != null) {
              final mimeType = lookupMimeType(viewModel.image!.path);
              if (mimeType == 'image/jpeg') {
                context.go(RoutePath.scannerCrop, extra: viewModel.image);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please select a JPEG image"),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please select an image"),
                  duration: Duration(seconds: 2),
                ),
              );
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
                          const Text(
                            "Choose Image",
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
                            const Text(
                              "Using Camera",
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
    );
  }
}
