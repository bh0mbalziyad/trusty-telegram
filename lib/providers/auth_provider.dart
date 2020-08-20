import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _tokenExpiryDate;
  String _userId;
  String apiKey;

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
      print(json.decode(response.body));
    } catch (error) {
      print(error);
      throw Exception(error);
    }
  }
}
