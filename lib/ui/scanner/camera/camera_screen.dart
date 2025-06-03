import 'package:camera/camera.dart';
import 'package:fluentzy/routing/paths.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/scanner/camera/camera_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ScannerCameraScreen extends StatelessWidget {
  const ScannerCameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CameraViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.image != null) {
        context.go(RoutePath.scannerCrop, extra: viewModel.image!);
      }
    });
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(RoutePath.scannerOptions);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () => {context.go(RoutePath.scannerOptions)},
            icon: SvgPicture.asset(
              "assets/back.svg",
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                viewModel.toggleFlash();
              },
              icon: Icon(
                viewModel.isFlashOn
                    ? Icons.flash_on_rounded
                    : Icons.flash_off_rounded,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              if (viewModel.isCameraInitialized) {
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    Expanded(child: CameraPreview(viewModel.controller)),
                    GestureDetector(
                      onTap: () {
                        viewModel.takePicture();
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
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
