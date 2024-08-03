import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_learning_app2/widgets/custom_app_bar.dart';

import '../../api/ApiServic.dart';

class QuestionsAndChoices extends StatefulWidget {
  final String topicName;
  const QuestionsAndChoices({Key? key, required this.topicName})
      : super(key: key);

  @override
  _QuestionsAndChoicesState createState() => _QuestionsAndChoicesState();
}

class _QuestionsAndChoicesState extends State<QuestionsAndChoices> {
  late Future<List<Map<String, String>>> futureQuestions;

  @override
  void initState() {
    super.initState();
    futureQuestions =
        ApiService().fetchQestionsWithRightChoice(widget.topicName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Questions and Choices'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffE8EAF6), Color(0xffF5F5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Map<String, String>>>(
          future: futureQuestions,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No questions found.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var question = snapshot.data![index];
                  return Container(
                    margin: const EdgeInsets.all(10.0),
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
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 8),
                          Text(
                            'Question ${index + 1}:',
                            style: const TextStyle(
                              fontFamily: 'JosefinSans',
                              color: Color.fromARGB(255, 46, 57, 109),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            question['question_text'] ??
                                'No Question Available',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 1,
                            itemBuilder: (context, choiceIndex) {
                              var choiceText = question['choice_text'] ??
                                  'No choice text available';
                              return ListTile(
                                title: Text(
                                  choiceText,
                                  style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
                                leading: const CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(218, 51, 65, 128),
                                  child: Icon(
                                    Icons.quiz_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
