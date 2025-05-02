class ListeningLesson {
  final String id;
  final String name;
  final String url;
  final int duration;
  final Map<String, String> transcripts;

  ListeningLesson({
    required this.id,
    required this.name,
    required this.url,
    required this.duration,
    required this.transcripts,
  });

  factory ListeningLesson.fromJson(Map<String, dynamic> json) {
    return ListeningLesson(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      duration: json['duration'] ?? 0,
      transcripts: Map<String, String>.from(json['transcripts'] ?? {}),
    );
  }
}
