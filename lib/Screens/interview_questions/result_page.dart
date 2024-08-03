import 'package:flutter/material.dart';

import '../home/home_page.dart';

// ignore: must_be_immutable
class ResultScreen extends StatefulWidget {
  int score;
  ResultScreen(this.score, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            const SizedBox(
              height: 45.0,
            ),
            const Text(
              "Your Score is",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 34.0,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              "${widget.score}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 85.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            RawMaterialButton(
              shape: const StadiumBorder(),
              fillColor: Color.fromARGB(255, 24, 35, 82),
              padding: const EdgeInsets.all(18.0),
              elevation: 1,
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ));
              },
              child: const Text(
                "Go to Home Page",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
