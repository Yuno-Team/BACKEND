class Policy {
  final String id;
  final String title;
  final String category;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String applicationUrl;
  final List<String> requirements;
  final int saves;
  final bool isBookmarked;

  Policy({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.applicationUrl,
    required this.requirements,
    this.saves = 0,
    this.isBookmarked = false,
  });

  factory Policy.fromJson(Map<String, dynamic> json) {
    return Policy(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      applicationUrl: json['applicationUrl'],
      requirements: List<String>.from(json['requirements'] ?? []),
      saves: json['saves'] ?? 0,
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'applicationUrl': applicationUrl,
      'requirements': requirements,
      'saves': saves,
      'isBookmarked': isBookmarked,
    };
  }
}
