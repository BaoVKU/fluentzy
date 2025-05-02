import 'package:camera/camera.dart';
import 'package:fluentzy/data/services/image_picker_service.dart';
import 'package:flutter/material.dart';

class OptionViewModel extends ChangeNotifier {
  final ImagePickerService _imagePickerService;
  XFile? _image;
  XFile? get image => _image;
  OptionViewModel(this._imagePickerService);

  Future<void> pickImage() async {
    _image = await _imagePickerService.pickImageFromGallery();
    notifyListeners();
  }
}