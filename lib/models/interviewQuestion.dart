import 'choice.dart';

class InterviewQuestion {
  final int id;
  final String questionText;
  final String topicName;
  final List<Choice> choices;

  InterviewQuestion({
    required this.id,
    required this.questionText,
    required this.topicName,
    required this.choices,
  });

  factory InterviewQuestion.fromJson(Map<String, dynamic> json) {
    var choicesList = json['choices'] as List;
    List<Choice> choiceItems =
        choicesList.map((choice) => Choice.fromJson(choice)).toList();

    return InterviewQuestion(
      id: json['id'],
      questionText: json['question_text'],
      topicName: json['topic_name'],
      choices: choiceItems,
    );
  }
}
