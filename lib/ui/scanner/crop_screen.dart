import 'dart:io';

import 'package:fluentzy/routing/paths.dart';
import 'package:fluentzy/ui/scanner/crop_view_model.dart';
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => {context.go(RoutePath.scannerOptions)},
          icon: SvgPicture.asset(
            "assets/back.svg",
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
                      return Image.network(viewModel.image.path, fit: BoxFit.cover);
                    } else {
                      return Image.file(
                        File(viewModel.image.path),
                        fit: BoxFit.cover,
                      );
                    }
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.go(RoutePath.scannerResult, extra: viewModel.image);
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
    );
  }
}
