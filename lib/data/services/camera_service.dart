import 'package:camera/camera.dart';

class CameraService {
  late CameraController _controller;
  CameraController get controller => _controller;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  bool _isFlashOn = false;
  bool get isFlashOn => _isFlashOn;

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      throw Exception("No cameras found on this device.");
    }

    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller.initialize();
    _isInitialized = true;
  }

  Future<XFile> takePicture() async {
    if (!_isInitialized) {
      throw Exception("Camera is not initialized.");
    }

    final XFile file = await _controller.takePicture();

    return file;
  }

  Future<void> toggleFlash() async {
    if (!_isInitialized) {
      throw Exception("Camera is not initialized.");
    }

    if (!_isFlashOn) {
      await _controller.setFlashMode(FlashMode.torch);
    } else {
      await _controller.setFlashMode(FlashMode.off);
    }

    _isFlashOn = !_isFlashOn;
  }

  Future<void> dispose() async {
    if (_isInitialized) {
      await _controller.dispose();
      _isInitialized = false;
    }
  }
}
