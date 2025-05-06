import 'package:camera/camera.dart';
import 'package:fluentzy/data/services/camera_service.dart';
import 'package:fluentzy/utils/logger.dart';
import 'package:flutter/foundation.dart';

class CameraViewModel extends ChangeNotifier {
  final CameraService _cameraService;
  bool get isCameraInitialized => _cameraService.isInitialized;
  CameraController get controller => _cameraService.controller;
  XFile? _image;
  XFile? get image => _image;
  bool get isFlashOn => _cameraService.isFlashOn;

  CameraViewModel(this._cameraService) {
    initCamera();
  }

  Future<void> initCamera() async {
    await _cameraService.initCamera();
    notifyListeners();
  }

  Future<void> takePicture() async {
    _image = await _cameraService.takePicture();
    Logger.error(
      "Image path: ${_image!.path} - ${(await _image!.length()) / 1024 / 1024} MB",
    );
    notifyListeners();
  }

  Future<void> toggleFlash() async {
    await _cameraService.toggleFlash();
    notifyListeners();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }
}
