import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exceptions.dart';

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;

  final String _url = 'https://flutter-shop-123.firebaseio.com';

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setIsFavorite(bool value) {
    this.isFavorite = value;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token) async {
    final String url = '$_url/products/${this.id}.json?auth=$token';
    final oldStatus = this.isFavorite;
    _setIsFavorite(!this.isFavorite);
    try {
      var response = await http.patch(
        url,
        body: json.encode({
          'isFavorite': this.isFavorite,
        }),
      );
      if (response.statusCode >= 400) {
        throw HttpException(
            'Failed PATCH.\nReponse code: ${response.statusCode}.');
      }
    } catch (error) {
      _setIsFavorite(oldStatus);
      throw HttpException(
          'Failed to update product.\nMessage: ${error.toString()}');
    }
  }
}
