class SpeakingProgress {
  final String lessonId;
  final int lastDoneIndex;

  SpeakingProgress({required this.lessonId, required this.lastDoneIndex});

  SpeakingProgress copy({String? newLessonId, int? newLastDoneIndex}) {
    return SpeakingProgress(
      lessonId: newLessonId ?? lessonId,
      lastDoneIndex: newLastDoneIndex ?? lastDoneIndex,
    );
  }

  factory SpeakingProgress.fromJson(Map<String, dynamic> json) {
    return SpeakingProgress(
      lessonId: json['lessonId'] as String,
      lastDoneIndex: json['lastDoneIndex'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'lessonId': lessonId, 'lastDoneIndex': lastDoneIndex};
  }
}
