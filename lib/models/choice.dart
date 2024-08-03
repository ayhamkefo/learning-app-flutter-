class Choice {
  final int id;
  final int questionId;
  final String choiceText;
  final int isCorrect;

  Choice({
    required this.id,
    required this.questionId,
    required this.choiceText,
    required this.isCorrect,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      id: json['id'],
      questionId: json['interview_question_id'],
      choiceText: json['choice_text'],
      isCorrect: json['is_correct'],
    );
  }
}
