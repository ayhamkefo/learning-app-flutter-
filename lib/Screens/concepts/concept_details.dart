// concept_details_page.dart
import 'package:flutter/material.dart';

import '../../models/concpt.dart';
import '../../widgets/custom_app_bar.dart';

class ConceptDetailsPage extends StatelessWidget {
  final Concept concept;

  const ConceptDetailsPage({super.key, required this.concept});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: concept.title,
        fontsize: 22,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.swipe_left,
              color: Color.fromARGB(218, 71, 89, 167),
              size: 30,
            ),
            SizedBox(
              width: 150,
            ),
            Icon(
              Icons.swipe_right,
              color: Color.fromARGB(218, 71, 89, 167),
              size: 30,
            ),
          ]),
          Expanded(
            child: PageView(
              children: [
                _buildCard(
                    title: 'Explanation',
                    content: concept.explanation,
                    icon: Icons.label_important_outline),
                _buildCard(
                    title: 'Sources',
                    content: concept.sources,
                    icon: Icons.link_outlined)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      {required String title,
      required String content,
      required IconData icon}) {
    bool needsExpanded = content.length > 500;
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8.0,
              spreadRadius: 2.0,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        margin: const EdgeInsets.all(25),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon,
                      color: const Color.fromARGB(218, 71, 89, 167), size: 27),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(218, 71, 89, 167),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (needsExpanded)
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      content,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              else
                Text(
                  content,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
