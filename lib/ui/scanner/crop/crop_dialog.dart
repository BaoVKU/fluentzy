import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CropDialog extends StatefulWidget {
  final Widget cropper;
  final VoidCallback initCropper;
  final Future<String?> Function() crop;
  final Function(RotationAngle) rotate;
  final Function(num) scale;
  final VoidCallback onCancel;
  final Function(String?) onCrop;

  const CropDialog({
    super.key,
    required this.cropper,
    required this.initCropper,
    required this.crop,
    required this.rotate,
    required this.scale,
    required this.onCancel,
    required this.onCrop,
  });

  @override
  State<CropDialog> createState() => _CropDialogState();
}

class _CropDialogState extends State<CropDialog> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) widget.initCropper();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: AppColors.background,
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.3, // (100% - 40%) / 2
        vertical: screenSize.height * 0.05, // (100% - 80%) / 2
      ),
      child: Container(
        width: screenSize.width * 0.4,
        height: screenSize.height * 0.9,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: widget.cropper),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                IconButton.outlined(
                  color: AppColors.background,
                  onPressed:
                      () => widget.rotate(RotationAngle.counterClockwise90),
                  icon: const Icon(Icons.rotate_left, color: AppColors.primary),
                ),
                IconButton.outlined(
                  color: AppColors.background,
                  onPressed: () => widget.rotate(RotationAngle.clockwise90),
                  icon: const Icon(
                    Icons.rotate_right,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onCancel, // cancel
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () async {
                    final result = await widget.crop();
                    widget.onCrop(result); // return result
                  },
                  child: Text(
                    AppLocalizations.of(context)!.crop,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
