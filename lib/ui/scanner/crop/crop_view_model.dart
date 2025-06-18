import 'package:camera/camera.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/scanner/crop/crop_dialog.dart';
import 'package:fluentzy/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CropViewModel extends ChangeNotifier {
  final XFile _originalImage;
  XFile get originalImage => _originalImage;

  XFile? _croppedImage;
  XFile? get croppedImage => _croppedImage;

  bool _isProcessed = false;
  bool get isProcessed => _isProcessed;

  CropViewModel(this._originalImage);

  Future<void> cropImage(BuildContext context) async {
    final CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: _originalImage.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: AppLocalizations.of(context)!.cropImage,
          toolbarColor: AppColors.primary,
          activeControlsWidgetColor: AppColors.primary,
          statusBarColor: AppColors.primary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: AppLocalizations.of(context)!.cropImage),
        WebUiSettings(
          context: context,
          size: CropperSize(
            width: (MediaQuery.of(context).size.width * 0.4).toInt(),
            height: (MediaQuery.of(context).size.height * 0.6).toInt(),
          ),
          customDialogBuilder: (cropper, initCropper, crop, rotate, scale) {
            return CropDialog(
              cropper: cropper,
              initCropper: initCropper,
              crop: crop,
              rotate: rotate,
              scale: scale,
              onCancel: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pop();
                });
              },
              onCrop: (path) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pop(path);
                });
              },
            );
          },
        ),
      ],
    );

    _isProcessed = true;

    if (cropped != null) {
      _croppedImage = XFile(cropped.path);
    }

    Logger.error(
      "CropViewModel: Cropped image path: ${_croppedImage?.path ?? 'No image cropped'}",
    );

    notifyListeners();
  }
}
