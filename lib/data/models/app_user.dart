class AppUser {
  final String id;
  final String name;
  final String email;
  final String plan;
  final String nativeLangCode;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.plan = 'free',
    this.nativeLangCode = 'vi',
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      plan: json['plan'] ?? 'free',
      nativeLangCode: json['nativeLangCode'] ?? 'vi',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'plan': plan,
      'nativeLangCode': nativeLangCode,
    };
  }
}
