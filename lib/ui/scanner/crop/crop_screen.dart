import 'dart:io';

import 'package:fluentzy/routing/app_route_path.dart';
import 'package:fluentzy/ui/scanner/crop/crop_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ScannerCropScreen extends StatelessWidget {
  const ScannerCropScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CropViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!viewModel.isProcessed) {
        viewModel.cropImage(context);
      }
    });
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(AppRoutePath.scannerOptions);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () => {context.go(AppRoutePath.scannerOptions)},
            icon: SvgPicture.asset(
              "assets/back.svg",
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (kIsWeb) {
                        return Image.network(
                          viewModel.croppedImage?.path ??
                              viewModel.originalImage.path,
                          fit: BoxFit.cover,
                        );
                      } else {
                        return Image.file(
                          File(
                            viewModel.croppedImage?.path ??
                                viewModel.originalImage.path,
                          ),
                          fit: BoxFit.cover,
                        );
                      }
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.go(
                      AppRoutePath.scannerResult,
                      extra: viewModel.croppedImage ?? viewModel.originalImage,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.black,
                      size: 30,
                    ),
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
