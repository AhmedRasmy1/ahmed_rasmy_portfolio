class Project {
  const Project({
    required this.id,
    required this.title,
    required this.summary,
    required this.tags,
  });

  final String id;
  final String title;
  final String summary;
  final List<String> tags;

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      tags: (json['tags'] as List<dynamic>? ?? const [])
          .map((e) => e as String)
          .toList(),
    );
  }
}
