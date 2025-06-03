class SpeakingLesson {
  final String id;
  final String name;
  final List<String> sentences;

  SpeakingLesson({this.id = '', required this.name, required this.sentences});

  factory SpeakingLesson.fromJson(Map<String, dynamic> json) {
    return SpeakingLesson(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      sentences: List<String>.from(json['sentences'] ?? []),
    );
  }
}
