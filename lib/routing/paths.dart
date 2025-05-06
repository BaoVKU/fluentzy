class RoutePath {
  RoutePath();
  static const main = '/';

  static const login = '${main}login';
  static const register = '${main}register';

  static const language = '${main}language';

  static const home = '${main}home';
  static const premium = '${main}premium';
  static const chat = '${main}chat';
  static const profile = '${main}profile';

  static const speaking = '${main}speaking';
  static const speakingRecord = '$speaking/record';
  static const speakingRecordWithId = '$speaking/record/:$lessonId';
  static const speakingLesson = '$speaking/lesson';
  static const speakingResult = '$speaking/result';

  static const listening = '${main}listening';
  static const listeningLesson = '$listening/lesson';
  static const listeningPlay = '$listening/play';
  static const listeningPlayWithId = '$listening/play/:$lessonId';

  static const scanner = '${main}scanner';
  static const scannerOptions = '$scanner/options';
  static const scannerCamera = '$scanner/camera';
  static const scannerCrop = '$scanner/crop';
  static const scannerResult = '$scanner/result';

  static const flashCard = '${main}flashcard';
  static const flashCardList = '$flashCard/list';
  static const flashCardCreate = '$flashCard/create';
  static const flashCardEdit = '$flashCard/edit';
  static const flashCardLearn = '$flashCard/learn';

  static const lessonId = 'lessonId';
}
