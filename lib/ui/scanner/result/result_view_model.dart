import 'package:camera/camera.dart';
import 'package:fluentzy/data/models/dictionary_entry.dart';
import 'package:fluentzy/data/models/response_state.dart';
import 'package:fluentzy/data/repositories/ai_repository.dart';
import 'package:fluentzy/data/repositories/dictionary_repository.dart';
import 'package:fluentzy/data/repositories/tts_repository.dart';
import 'package:fluentzy/utils/image_util.dart';
import 'package:fluentzy/utils/logger.dart';
import 'package:flutter/foundation.dart';

class ScannerResultViewModel extends ChangeNotifier {
  final AiRepository _aiRepository;
  final DictionaryRepository _dictionaryRepository;
  final TtsRepository _ttsRepository;
  final XFile _image;
  XFile get image => _image;
  ResponseState _responseState = Initial();
  ResponseState get responseState => _responseState;
  bool get isSpeaking => _ttsRepository.isSpeaking;
  ScannerResultViewModel(
    this._aiRepository,
    this._dictionaryRepository,
    this._ttsRepository,
    this._image,
  ) {
    detectObject();
  }

  Future<void> detectObject() async {
    _responseState = Loading();
    notifyListeners();
    final bytes = await compressImage();
    Logger.error(
      "compressed ${image.path}: ${bytes.lengthInBytes / 1024 / 1024} MB",
    );

    final name = await _aiRepository.detectObject(bytes);

    if (name == null) {
      _responseState = Error("Error occurred while detecting object.");
      notifyListeners();
      return;
    }

    final dictionary = await _dictionaryRepository.getDefinition(name);

    if (dictionary == null) {
      _responseState = Error("Error occurred while getting definition.");
      notifyListeners();
      return;
    }

    _responseState = Success(dictionary);

    if (_responseState is Success) {
      final successState = _responseState as Success;
      final data = successState.data as DictionaryEntry;
      Logger.errorWithTag("ResultViewModel", "Detected object: $data");
    }
    notifyListeners();
  }

  Future<Uint8List> compressImage() async {
    Uint8List? bytes;
    if (kIsWeb) {
      bytes = await ImageUtil.compressImageWeb(_image);
    } else {
      bytes = await ImageUtil.compressImageMobile(_image);
    }
    return bytes;
  }

  Future<void> playSpeaker({required String text}) async {
    await _ttsRepository.playSpeaker(text: text);
    notifyListeners();
  }

  Future<void> stopSpeaker() async {
    await _ttsRepository.stopSpeaker();
    notifyListeners();
  }
}
