// concept_viewer.dart
import 'package:flutter/material.dart';
import '../../models/concpt.dart';
import 'concept_details.dart';

class ConceptViewer extends StatefulWidget {
  final List<Concept> concepts;

  const ConceptViewer({super.key, required this.concepts});

  @override
  _ConceptViewerState createState() => _ConceptViewerState();
}

class _ConceptViewerState extends State<ConceptViewer> {
  int _currentIndex = 0;

  void _nextConcept() {
    setState(() {
      if (_currentIndex < widget.concepts.length - 1) {
        _currentIndex++;
      }
    });
  }

  void _previousConcept() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: _previousConcept,
              color: _currentIndex == 0
                  ? Colors.grey
                  : const Color.fromARGB(237, 37, 44, 74),
            ),
            Expanded(
                child: ConceptCard(concept: widget.concepts[_currentIndex])),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: _nextConcept,
              color: _currentIndex == widget.concepts.length - 1
                  ? Colors.grey
                  : const Color.fromARGB(237, 37, 44, 74),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConceptDetailsPage(
                  concept: widget.concepts[_currentIndex],
                ),
              ),
            );
          },
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
            Color.fromARGB(255, 56, 70, 131),
          )),
          child: const Text(
            'Read More',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class ConceptCard extends StatelessWidget {
  final Concept concept;

  const ConceptCard({super.key, required this.concept});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                concept.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              concept.explanation,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
