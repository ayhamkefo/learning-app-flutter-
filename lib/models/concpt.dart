class Concept {
  final int id;
  final String topicName;
  final String title;
  final String explanation;
  final String sources;

  Concept({
    required this.id,
    required this.topicName,
    required this.title,
    required this.explanation,
    required this.sources,
  });

  factory Concept.fromJson(Map<String, dynamic> json) {
    return Concept(
      id: json['id'],
      topicName: json['topic_name'],
      title: json['title'],
      explanation: json['explanation'],
      sources: json['sources'],
    );
  }
}
