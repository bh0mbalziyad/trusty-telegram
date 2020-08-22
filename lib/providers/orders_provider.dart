import 'dart:convert';
import "package:flutter/foundation.dart";
import 'package:http/http.dart' as http;

import './cart_provider.dart' show Cart;

class Order {
  final String id;
  final double amount;
  final List<Cart> products;
  final DateTime orderTime;

  Order({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.orderTime,
  });
}

class OrdersProvider with ChangeNotifier {
  List<Order> _orders = [];

  final String _url = 'https://flutter-shop-123.firebaseio.com';
  String _authToken;

  void setToken(String token) => this._authToken = token;

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = '$_url/orders.json?auth=$_authToken';
    var response = await http.get(url);
    List<Order> loadedItems = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) return;
    extractedData.forEach((orderId, orderData) {
      loadedItems.add(Order(
        id: orderId,
        amount: orderData['amount'],
        orderTime: DateTime.parse(orderData['orderTime']),
        products: (orderData['products'] as List<dynamic>)
            .map((cartItem) => Cart(
                id: cartItem['id'],
                title: cartItem['title'],
                price: cartItem['price'],
                quantity: cartItem['quantity']))
            .toList(),
      ));
    });
    _orders = loadedItems.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<Cart> cartItems, double total) async {
    final String url = '$_url/orders.json?auth=$_authToken';
    final orderTime = DateTime.now();

    var response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'orderTime': orderTime.toIso8601String(),
        'products': cartItems
            .map((singleCartItem) => {
                  'id': singleCartItem.id,
                  'title': singleCartItem.title,
                  'quantity': singleCartItem.quantity,
                  'price': singleCartItem.price,
                })
            .toList(),
      }),
    );

    final order = Order(
      id: json.decode(response.body)['name'] as String,
      amount: total,
      products: cartItems,
      orderTime: orderTime,
    );
    _orders.insert(0, order);
    notifyListeners();
  }
}
