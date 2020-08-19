import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _tokenExpiryDate;
  String _userId;

  Future<void> signUp(String email, String password) async {
    String apiKey = "AIzaSyBBn55bheAZUr6Z4-t2zhkw-RChrOyTe1g";
    String url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey";
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
