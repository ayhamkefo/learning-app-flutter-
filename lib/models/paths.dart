class ProgrammingPath {
  final int id;
  final String title;
  final String description;
  final String sources;
  final String roles;
  final String challenges;
  final String interests;
  final String frameworks;
  final String stepsToLearn;

  ProgrammingPath({
    required this.id,
    required this.title,
    required this.description,
    required this.sources,
    required this.roles,
    required this.challenges,
    required this.interests,
    required this.frameworks,
    required this.stepsToLearn,
  });

  factory ProgrammingPath.fromJson(Map<String, dynamic> json) {
    return ProgrammingPath(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      sources: json['sources'],
      roles: json['roles'],
      challenges: json['challenges'],
      interests: json['interests'],
      frameworks: json['frameworks'],
      stepsToLearn: json['steps_to_learn'],
    );
  }
}
