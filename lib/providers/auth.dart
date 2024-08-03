import 'dart:async';
import 'dart:convert' as converter;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import '../method/sheradPrefefrancesManger.dart';
import '../models/User.dart';

class Auth extends ChangeNotifier {
  bool _authenticated = false;
  User? _user;
  String? _errorMessage;
  User? get user => _user;
  bool get authenticated => _authenticated;
  String? get errorMessge => _errorMessage;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final String _baseUrl = 'http://10.0.2.2:8000/api/auth';
  String? _changePasswordMessage;
  String? get changePasswordMessage => _changePasswordMessage;
  Map<String, List<String>>? _validationErrors;
  Map<String, List<String>>? get validationErrors => _validationErrors;
  void resetErrorMessage() {
    _errorMessage = null;
    _validationErrors = null; // Reset validation errors
  }

  Future register({name, email, password}) async {
    var url = Uri.parse('$_baseUrl/register');
    try {
      var response = await http.post(url, body: {
        'name': '$name',
        'email': '$email',
        'password': '$password',
        'device_name': 'AuthToken'
      });
      if (response.statusCode == 200) {
        print(response.statusCode);
        var body = await converter.jsonDecode(response.body);
        String token = body['token'];
        await attempt(token);
        await storToken(token);
        _errorMessage = null;
      } else {
        var body = await converter.jsonDecode(response.body);
        Map<String, dynamic> message = body['message'];
        List<dynamic> errors = message['email'];
        _errorMessage = errors[0];
        log(response.body);
      }
    } catch (e) {
      log('error logg ${e.toString()}');
      throw Exception('An Unxpected Error Occurred');
    }
  }

  Future login({email, password}) async {
    var url = Uri.parse('$_baseUrl/login');
    try {
      var response = await http.post(url, body: {
        'email': '$email',
        'password': '$password',
        'device_name': 'AuthToken'
      });
      if (response.statusCode == 200) {
        var body = await converter.jsonDecode(response.body);
        String token = body['token'];
        await attempt(token);
        await storToken(token);
        _errorMessage = null;
      } else {
        var body = await converter.jsonDecode(response.body);
        _errorMessage = body['message'];
        log(response.body);
      }
    } catch (e) {
      log('error log ${e.toString()}');
      throw Exception('An Unxpected Error Occurred');
    }
  }

  Future logout() async {
    _isLoading = true;
    notifyListeners();
    var url = Uri.parse('$_baseUrl/logout');
    String token = await getToken();
    _authenticated = false;
    await http.delete(url, headers: {
      'Authorization': 'Bearer $token',
    });
    await deleteToken();
    _isLoading = false;
    notifyListeners();
  }

  Future attempt(String? token) async {
    _isLoading = true;
    notifyListeners();
    var url = Uri.parse('$_baseUrl/user');
    try {
      var response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        var data = await converter.jsonDecode(response.body);
        _user = User.fromJson(data);
        _authenticated = true;
      } else {
        _authenticated = false;
      }
    } catch (e) {
      log('error log ${e.toString()}');
      _authenticated = false;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future storToken(token) async {
    SharedPreferences prfs = await SharedPreferencesManager.getInstance();
    prfs.setString('auth', token);
  }

  Future getToken() async {
    SharedPreferences prfs = await SharedPreferencesManager.getInstance();
    return prfs.getString('auth');
  }

  Future deleteToken() async {
    SharedPreferences prfs = await SharedPreferencesManager.getInstance();
    prfs.clear();
  }

  Future<void> updateProfile(
      {String? name, String? email, File? profilePhoto}) async {
    String token = await getToken();
    var url = Uri.parse(
        'http://10.0.2.2:8000/api/student/update-profile/${_user?.id}');
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    if (name != null) {
      request.fields['name'] = name;
    }
    if (email != null) {
      request.fields['email'] = email;
    }
    if (profilePhoto != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'profile_photo', profilePhoto.path));
    }
    var response = await request.send();
    var responseData = await http.Response.fromStream(response);
    var data = converter.jsonDecode(responseData.body);
    if (response.statusCode == 200) {
      _user = User.fromJson(data['user']);
      _errorMessage = null;
    } else if (response.statusCode == 422) {
      _errorMessage = data['message'];
    } else {
      _errorMessage = 'Failed to updated the profile pleas try leater';
    }
    notifyListeners();
  }

  Future<void> changePassword(
      {required String currentPassword, required String newPassword}) async {
    String token = await getToken();
    var url =
        Uri.parse('http://10.0.2.2:8000/api/student/change-password/${_user?.id}');
    var response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPassword,
      },
    );
    var responseBody = converter.jsonDecode(response.body);

    if (response.statusCode == 200) {
      _changePasswordMessage = responseBody['message'];
      _errorMessage = null;
      _validationErrors = null;
    } else if (response.statusCode == 422) {
      if (responseBody['message'] is Map<String, dynamic>) {
        _validationErrors =
            Map<String, List<String>>.from(responseBody['message']);
        _errorMessage = null;
      } else {
        _errorMessage = responseBody['message'];
        _validationErrors = null;
      }
    } else {
      _errorMessage = 'failed to change the password pleas try leater';
      _validationErrors = null;
    }
  }

  Future<void> deleteAccount() async {
    _isLoading = true;
    notifyListeners();
    var url = Uri.parse('http://10.0.2.2:8000/api/student/delelte-account');
    String token = await getToken();
    _authenticated = false;
    await http.delete(url, headers: {
      'Authorization': 'Bearer $token',
    });
    await deleteToken();
    _isLoading = false;
    notifyListeners();
  }
}
