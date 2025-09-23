class Policy {
  final String id;
  final String title;
  final String? category;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? applicationUrl;
  final List<String> requirements;
  final int saves;
  final bool isBookmarked;

  Policy({
    required this.id,
    required this.title,
    this.category,
    this.description,
    this.startDate,
    this.endDate,
    this.applicationUrl,
    this.requirements = const [],
    this.saves = 0,
    this.isBookmarked = false,
  });

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is String) {
      try {
        return DateTime.parse(v);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static List<String> _parseStringList(dynamic v) {
    if (v == null) return [];
    if (v is List) {
      return v.map((e) => e is String ? e : e.toString()).toList();
    }
    return [];
  }

  factory Policy.fromJson(Map<String, dynamic> json) {
    final start = json['start_date'] ?? json['startDate'];
    final end = json['end_date'] ?? json['endDate'] ?? json['deadline'];
    final appUrl = json['application_url'] ?? json['applicationUrl'];
    final saves = json['bookmark_count'] ?? json['saves'] ?? 0;
    return Policy(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      category: json['category']?.toString(),
      description: json['description']?.toString(),
      startDate: _parseDate(start),
      endDate: _parseDate(end),
      applicationUrl: appUrl?.toString(),
      requirements: _parseStringList(json['requirements']),
      saves: saves is int ? saves : int.tryParse(saves.toString()) ?? 0,
      isBookmarked: (json['isBookmarked'] ?? false) == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'description': description,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'application_url': applicationUrl,
      'requirements': requirements,
      'saves': saves,
      'isBookmarked': isBookmarked,
    };
  }
}
