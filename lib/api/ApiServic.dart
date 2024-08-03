import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../method/sheradPrefefrancesManger.dart';
import '../models/concpt.dart';
import '../models/interviewQuestion.dart';
import '../models/paths.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<ProgrammingPath>> fetchPaths() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/student/paths'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> pathsJson = data['paths'];
      return pathsJson.map((json) => ProgrammingPath.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load paths');
    }
  }

  Future<ProgrammingPath> fetchPath(int id) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/student/paths/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProgrammingPath.fromJson(data['path']);
    } else {
      throw Exception('Failed to load this path');
    }
  }

  Future<Map<String, List<Concept>>> fetchAndGroupConcepts() async {
    var url = Uri.parse('$baseUrl/student/concepts');
    final prefs = await SharedPreferencesManager.getInstance();
    final token = prefs.getString('auth') ?? '';
    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List<dynamic> conceptsJson = jsonResponse['concepts'];
      List<Concept> concepts =
          conceptsJson.map((concept) => Concept.fromJson(concept)).toList();
      Map<String, List<Concept>> grouped = {};
      for (var concept in concepts) {
        if (!grouped.containsKey(concept.topicName)) {
          grouped[concept.topicName] = [];
        }
        grouped[concept.topicName]!.add(concept);
      }
      return grouped;
    } else {
      throw Exception('Failed to load concpts');
    }
  }

  Future<Map<String, List<InterviewQuestion>>> fetchQuestions() async {
    final token = await getToken();
    var url = Uri.parse('$baseUrl/student/questions');
    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)['questions'];
      List<InterviewQuestion> questions =
          body.map((dynamic item) => InterviewQuestion.fromJson(item)).toList();
      Map<String, List<InterviewQuestion>> grouped = {};
      for (var question in questions) {
        if (!grouped.containsKey(question.topicName)) {
          grouped[question.topicName] = [];
        }
        grouped[question.topicName]!.add(question);
      }
      return grouped;
    } else {
      throw Exception('Failed to load questions');
    }
  }

  Future<List<Map<String, String>>> fetchQestionsWithRightChoice(
      String topicName) async {
    final token = await getToken();
    var url = Uri.parse('$baseUrl/student/questions-true-choice/$topicName');
    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      List<Map<String, String>> questionAndChoiceList = [];
      for (var question in body['questions']) {
        String questionText = question['question_text'];
        if (question['choices'].isNotEmpty) {
          String choiceText = question['choices'][0]['choice_text'];
          questionAndChoiceList.add({
            'question_text': questionText,
            'choice_text': choiceText,
          });
        }
      }
      print(questionAndChoiceList);
      return questionAndChoiceList;
    } else {
      throw Exception('Failed to load questions');
    }
  }

  Future getToken() async {
    final prefs = await SharedPreferencesManager.getInstance();
    return prefs.getString('auth') ?? '';
  }
}
