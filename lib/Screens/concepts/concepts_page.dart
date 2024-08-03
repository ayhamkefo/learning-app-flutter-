import 'package:flutter/material.dart';

import '../../api/ApiServic.dart';
import '../../models/concpt.dart';
import '../../widgets/custom_app_bar.dart';
import 'concept_viewer.dart';

class ConceptsPage extends StatefulWidget {
  const ConceptsPage({super.key});

  @override
  State<ConceptsPage> createState() => _ConceptsPageState();
}

class _ConceptsPageState extends State<ConceptsPage> {
  late Future<Map<String, List<Concept>>> futureConcept;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    futureConcept = ApiService().fetchAndGroupConcepts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: CustomAppBar(title: 'Learn more'),
      body: FutureBuilder<Map<String, List<Concept>>>(
        future: futureConcept,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No concepts found'));
          } else {
            return Stepper(
              currentStep: _currentStep,
              onStepTapped: (step) => setState(() => _currentStep = step),
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Container();
              },
              steps: snapshot.data!.entries.map((entry) {
                String topicName = entry.key;
                List<Concept> concepts = entry.value;
                return Step(
                  title: Text(
                    topicName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  content: ConceptViewer(concepts: concepts),
                );
              }).toList(),
              connectorColor: const MaterialStatePropertyAll(
                Color.fromARGB(255, 56, 70, 131),
              ),
            );
          }
        },
      ),
    );
  }
}
