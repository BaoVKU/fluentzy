import 'package:fluentzy/data/models/transcript_line.dart';

class ListeningLesson {
  final String id;
  final String name;
  final String url;
  final int duration;
  final List<TranscriptLine> transcripts;
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
      transcripts: (json['transcripts'] as List).map((e) => TranscriptLine.fromJson(e)).toList()
    );
  }
}
