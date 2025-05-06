import 'package:camera/camera.dart';
import 'package:fluentzy/data/services/image_picker_service.dart';
import 'package:fluentzy/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

class OptionViewModel extends ChangeNotifier {
  final ImagePickerService _imagePickerService;
  XFile? _image;
  XFile? get image => _image;
  String? _imageMimeType;
  String? get imageMimeType => _imageMimeType;
  OptionViewModel(this._imagePickerService);

  Future<void> pickImage() async {
    _image = await _imagePickerService.pickImageFromGallery();
    if (kIsWeb) {
      _imageMimeType = lookupMimeType(
        '',
        headerBytes: await _image!.readAsBytes(),
      );
    } else {
      _imageMimeType = lookupMimeType(_image!.path);
    }
    Logger.error('Image mime type: $_imageMimeType');
    notifyListeners();
  }
}
