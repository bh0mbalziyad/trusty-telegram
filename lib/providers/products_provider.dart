import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exceptions.dart';
import 'product.dart';

class ProductsProvider with ChangeNotifier {
  // bool _showFavoritesOnly = false;
  final _url = "https://flutter-shop-123.firebaseio.com";

  List<Product> _items = [];
  // List<Product> _items = [
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),];

  List<Product> get items {
    // if (_showFavoritesOnly) return _items.where((product) => product.isFavorite).toList();
    return [..._items];
  }

  Future<void> fetchAndSetProducts() async {
    final url = "$_url/products.json";
    try {
      final response = await http.get(url);
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      fetchedData.forEach((productId, productData) {
        loadedProducts.insert(
          0,
          Product(
            id: productId,
            title: productData['title'],
            price: productData['price'],
            description: productData['description'],
            imageUrl: productData['imageUrl'],
            isFavorite: productData['isFavorite'],
          ),
        );
      });

      _items = loadedProducts;
      notifyListeners();
    } on Exception catch (error) {
      throw (error);
    }
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere(
      (element) => element.id == id,
      orElse: () {
        return new Product(
          id: null,
          description: '',
          price: 0,
          imageUrl: '',
          title: '',
        );
      },
    );
  }

  Future<void> addProduct(Product newProduct) async {
    final url = "$_url/products.json";
    var response = await http.post(url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'isFavorite': newProduct.isFavorite,
          },
        ));
    newProduct.id = json.decode(response.body)['name'] as String;
    _items.add(newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(Product newProduct) async {
    final url = "$_url/products/${newProduct.id}.json";
    final productIndex =
        _items.indexWhere((product) => product.id == newProduct.id);
    if (productIndex >= 0) {
      try {
        final response = await http.patch(
          url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }),
        );
        print('Response code: ${response.statusCode}');
        _items[productIndex] = newProduct;
        notifyListeners();
      } catch (error, stacktrace) {
        print('Stack trace: ${stacktrace.toString()}');
        throw error;
      }
    } else {
      throw "Couldn't find product in local list via ID";
    }
  }

  Future<void> removeProduct(String id) async {
    final url = '$_url/products/$id.json';
    final indexOfProduct = _items.indexWhere((element) => element.id == id);
    var copyOfProduct = _items[indexOfProduct];
    _items.removeAt(indexOfProduct);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode == 405) {
      _items.insert(indexOfProduct, copyOfProduct);
      notifyListeners();
      throw HttpException('Could not delete product on remote server');
    }

    copyOfProduct = null;
  }

  // void showFavorites() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }
}
