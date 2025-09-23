class User {
  final String id;
  final String email;
  final String name;
  final DateTime? birthDate;
  final String? region;
  final String? school;
  final String? education;
  final String? major;
  final List<String> interests;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.birthDate,
    this.region,
    this.school,
    this.education,
    this.major,
    this.interests = const [],
    required this.createdAt,
  });

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is String) {
      try { return DateTime.parse(v); } catch (_) { return null; }
    }
    return null;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final birth = json['birth_date'] ?? json['birthDate'];
    final created = json['created_at'] ?? json['createdAt'];
    return User(
      id: (json['id'] ?? json['uuid'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      birthDate: _parseDate(birth),
      region: json['region']?.toString(),
      school: json['school']?.toString(),
      education: json['education']?.toString(),
      major: json['major']?.toString(),
      interests: (json['interests'] is List)
          ? List<String>.from(json['interests'] as List)
          : const [],
      createdAt: _parseDate(created) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'birthDate': birthDate?.toIso8601String(),
      'region': region,
      'school': school,
      'education': education,
      'major': major,
      'interests': interests,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    DateTime? birthDate,
    String? region,
    String? school,
    String? education,
    String? major,
    List<String>? interests,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      region: region ?? this.region,
      school: school ?? this.school,
      education: education ?? this.education,
      major: major ?? this.major,
      interests: interests ?? this.interests,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
