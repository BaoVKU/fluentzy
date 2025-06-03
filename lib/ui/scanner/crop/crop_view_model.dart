import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CropViewModel extends ChangeNotifier {
  final XFile _image;
  XFile get image => _image;

  CropViewModel(this._image);
}
