import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/http_exceptions.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _tokenExpiryDate;
  String _userId;
  String apiKey;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token == null) return null;
    if (_tokenExpiryDate == null) return null;
    if (!_tokenExpiryDate.isAfter(DateTime.now())) return null;
    return _token;
  }

  AuthProvider() {
    this.apiKey = "AIzaSyBBn55bheAZUr6Z4-t2zhkw-RChrOyTe1g"; // Load from env
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(
      email: email,
      password: password,
      urlSegment: "signUp",
    );
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(
      email: email,
      password: password,
      urlSegment: "signInWithPassword",
    );
  }

  Future<void> _authenticate({
    @required String email,
    @required String password,
    @required String urlSegment,
  }) async {
    final String url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey";
    try {
      var response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseBody = json.decode(response.body);
      if (responseBody['error'] != null) {
        throw HttpException(responseBody['eror']['message']);
      }
      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      _tokenExpiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseBody['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
