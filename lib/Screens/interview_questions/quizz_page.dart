import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/interviewQuestion.dart';
import 'result_page.dart';

class QuizzScreen extends StatefulWidget {
  final List<InterviewQuestion> questions;
  const QuizzScreen({super.key, required this.questions});

  @override
  _QuizzScreenState createState() => _QuizzScreenState();
}

class _QuizzScreenState extends State<QuizzScreen> {
  int questionPos = 0;
  int score = 0;
  bool btnPressed = false;
  PageController? _controller;
  bool answered = false;
  Timer? _timer;
  int _remainingTime = 60;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _remainingTime = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          timer.cancel();
          nextQuestion();
        }
      });
    });
  }

  void nextQuestion() {
    if (_controller!.page?.toInt() == widget.questions.length - 1) {
      _timer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResultScreen(score)),
      );
    } else {
      _controller!.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInExpo,
      );
      setState(() {
        btnPressed = false;
        answered = false;
        startTimer();
      });
    }
  }

  void answerQuestion(bool isCorrect) {
    if (isCorrect) {
      score++;
    }
    setState(() {
      btnPressed = true;
      answered = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      nextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF252c4a),
              Color.fromARGB(255, 56, 70, 131),
              Color.fromARGB(223, 87, 94, 119),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: PageView.builder(
            controller: _controller!,
            onPageChanged: (page) {
              setState(() {
                answered = false;
                startTimer();
              });
            },
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Question ${index + 1}/${widget.questions.length}",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Time remaining: $_remainingTime seconds',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: widget.questions[index].questionText.length * 2,
                    child: Text(
                      widget.questions[index].questionText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                  for (int i = 0;
                      i < widget.questions[index].choices.length;
                      i++)
                    Container(
                      width: MediaQuery.of(context).size.width * 2,
                      height: MediaQuery.of(context).size.width * 0.25,
                      margin: const EdgeInsets.only(
                          bottom: 20.0, left: 12.0, right: 12.0),
                      child: RawMaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        fillColor: btnPressed
                            ? widget.questions[index].choices[i].isCorrect == 1
                                ? Colors.green[600]
                                : Colors.red[600]
                            : const Color.fromARGB(223, 37, 44, 74),
                        onPressed: !answered
                            ? () {
                                answerQuestion(widget.questions[index]
                                        .choices[i].isCorrect ==
                                    1);
                              }
                            : null,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, top: 5),
                            child: Text(
                              widget.questions[index].choices[i].choiceText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
            itemCount: widget.questions.length,
          ),
        ),
      ),
    );
  }
}
