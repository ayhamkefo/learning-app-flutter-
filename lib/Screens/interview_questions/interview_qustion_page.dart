import 'package:flutter/material.dart';
import 'package:flutter_learning_app2/Screens/interview_questions/questions-and-choices.dart';
import '../../api/ApiServic.dart';
import '../../models/interviewQuestion.dart';
import '../../widgets/custom_app_bar.dart';
import '../paths/paths_page.dart';
import 'quizz_page.dart';

class InterviewQuestionsPage extends StatefulWidget {
  const InterviewQuestionsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InterviewQuestionsPageState createState() => _InterviewQuestionsPageState();
}

class _InterviewQuestionsPageState extends State<InterviewQuestionsPage> {
  late Future<Map<String, List<InterviewQuestion>>> futureQuestions;

  @override
  void initState() {
    super.initState();
    futureQuestions = ApiService().fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Test Your Knowledge'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffE8EAF6), Color(0xffF5F5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<Map<String, List<InterviewQuestion>>>(
          future: futureQuestions,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView(
                padding: const EdgeInsets.all(20),
                children: snapshot.data!.entries.map((entry) {
                  String topicName = entry.key;
                  List<InterviewQuestion> questions = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: QustionsListTile(
                        questions: questions,
                        topicName: topicName,
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}

class QustionsListTile extends StatelessWidget {
  final List<InterviewQuestion> questions;
  final String topicName;
  const QustionsListTile(
      {super.key, required this.questions, required this.topicName});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: chooseIcon(topicName),
      title: Text(
        topicName,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 5),
                Text(
                  "${questions.length} Questions",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.alarm,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 5),
                Text(
                  "${(questions.length * 1).toStringAsFixed(1)} min",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      trailing: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            color: Colors.amber,
          ),
          SizedBox(height: 4),
          Text(
            "4.5",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      onTap: () {
        showTestExplanationBottomSheet(context, topicName, questions);
      },
    );
  }
}

void showTestExplanationBottomSheet(
    BuildContext context, String topicName, List<InterviewQuestion> questions) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  const Text(
                    'Brief explanation about this test',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.menu_book, color: Color(0xFF252c4a)),
                    ),
                    title: Text(
                      "${questions.length} Qustions",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      '10 points for each question',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                      child: Icon(
                        Icons.alarm_outlined,
                        color: Color(0xFF252c4a),
                      ),
                    ),
                    title: const Text(
                      'Total Duration',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${(questions.length * 1).toStringAsFixed(1)} min',
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.star_border_outlined,
                          color: Color(0xFF252c4a)),
                    ),
                    title: Text(
                      'Win ${questions.length} Stars',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'Answer all the questions correctly',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF252c4a),
                      //padding: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuizzScreen(questions: questions),
                          ));
                    },
                    child: const Text(
                      'Start Quiz',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF252c4a),
                      //padding: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionsAndChoices(
                              topicName: topicName,
                            ),
                          ));
                    },
                    child: const Text(
                      'See All The Question',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      });
}
