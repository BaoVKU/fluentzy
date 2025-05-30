class Definition {
  final String definition;
  final String? example;

  Definition({required this.definition, this.example});

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      definition: json['definition'] ?? '',
      example: json['example'],
    );
  }
}
