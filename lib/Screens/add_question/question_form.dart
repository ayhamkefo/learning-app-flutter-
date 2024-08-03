import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/custom_app_bar.dart';
import '../home/home_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class QuestionForm extends StatefulWidget {
  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  final _formKey = GlobalKey<FormState>();
  final String baseUrl = 'http://10.0.2.2:8000/api';
  String questionText = '';
  String topicName = '';
  List<Map<String, dynamic>> choices = [
    {'text': '', 'isTrue': 0},
    {'text': '', 'isTrue': 0},
    {'text': '', 'isTrue': 0},
    {'text': '', 'isTrue': 0},
  ];
  int correctChoiceIndex = -1;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && correctChoiceIndex != -1) {
      _formKey.currentState!.save();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth') ?? '';

      // Submit question
      final questionResponse = await http.post(
        Uri.parse('$baseUrl/student/questions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'question_text': questionText,
          'topic_name': topicName,
        }),
      );

      if (questionResponse.statusCode == 200) {
        final questionId = jsonDecode(questionResponse.body)['id'];

        // Submit choices
        for (var i = 0; i < choices.length; i++) {
          await http.post(
            Uri.parse('$baseUrl/student/questions/$questionId/choices'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode({
              'choice_text': choices[i]['text'],
              'is_true': choices[i]['isTrue'],
            }),
          );
        }

        _showSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add question'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please ensure all choices are filled and a correct choice is selected.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    AwesomeDialog(
        context: context,
        dialogBorderRadius: BorderRadius.circular(20),
        btnOkColor: const Color.fromARGB(255, 24, 35, 82),
        headerAnimationLoop: false,
        animType: AnimType.topSlide,
        title: 'Submission Successful',
        desc:
            'The question submitted successfully.Wait for it to be reviewed by an admin.',
        descTextStyle: const TextStyle(fontSize: 15),
        btnOkOnPress: () {
          Navigator.of(context).pop();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        },
        customHeader: const Icon(
          Icons.check_circle_sharp,
          size: 100,
          color: Color.fromARGB(255, 24, 35, 82),
        )).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Add Question'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffE8EAF6), Color(0xffF5F5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Please enter a valid question and four choices for it. \nNote: If you enter an incorrect question it will be rejected. ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 24, 35, 82),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Topic Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.topic_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a topic name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    topicName = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Question Text',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.question_mark_outlined),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a question';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    questionText = value!;
                  },
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: choices.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ChoiceInput(
                        choice: choices[index],
                        isSelected: index == correctChoiceIndex,
                        onChanged: (text, isTrue) {
                          setState(() {
                            choices[index]['text'] = text;
                            if (isTrue) {
                              correctChoiceIndex = index;
                              for (var i = 0; i < choices.length; i++) {
                                choices[i]['isTrue'] = i == index ? 1 : 0;
                              }
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
                RawMaterialButton(
                  shape: const StadiumBorder(),
                  fillColor: const Color.fromARGB(255, 24, 35, 82),
                  padding: const EdgeInsets.all(15.0),
                  elevation: 0,
                  onPressed: _submitForm,
                  child: const Text(
                    "      Submit     ",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChoiceInput extends StatelessWidget {
  final Map<String, dynamic> choice;
  final bool isSelected;
  final Function(String, bool) onChanged;

  ChoiceInput(
      {required this.choice,
      required this.isSelected,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: choice['text'],
            decoration: const InputDecoration(
                labelText: 'Choice Text',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.quiz_outlined)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a choice';
              }
              return null;
            },
            onChanged: (value) {
              onChanged(value, isSelected);
            },
          ),
        ),
        Radio(
          value: true,
          groupValue: isSelected,
          onChanged: (value) {
            onChanged(choice['text'], true);
          },
          activeColor: const Color.fromARGB(255, 24, 35, 82),
        ),
        Text(
          isSelected ? 'Correct Choice' : '',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? const Color.fromARGB(255, 24, 35, 82)
                  : Colors.red),
        ),
      ],
    );
  }
}
