class SpeakingResponse {
  final String feedback;
  final int rate;
  final String ipa;
  
  SpeakingResponse({
    required this.feedback,
    required this.rate,
    required this.ipa,
  });

  factory SpeakingResponse.fromJson(Map<String, dynamic> json) {
    return SpeakingResponse(
      feedback: json['feedback'] as String,
      rate: json['rate'] as int,
      ipa: json['ipa'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'feedback': feedback, 'rate': rate, 'ipa': ipa};
  }
}
