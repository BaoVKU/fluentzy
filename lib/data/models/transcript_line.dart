class TranscriptLine {
  final Duration start;
  final String en;
  final String vi;

  TranscriptLine({required this.start, required this.en, required this.vi});

  factory TranscriptLine.fromJson(Map<String, dynamic> json) {
    return TranscriptLine(
      start: Duration(seconds: json['start']),
      en: json['en'] ?? '',
      vi: json['vi'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'start': start.inSeconds, 'en': en, 'vi': vi};
  }
}
