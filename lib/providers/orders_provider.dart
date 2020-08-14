import "package:flutter/foundation.dart";

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

  List<Order> get orders {
    return [..._orders];
  }

  void addOrder(List<Cart> cartItems, double total) {
    final order = Order(
      id: DateTime.now().toString(),
      amount: total,
      products: cartItems,
      orderTime: DateTime.now(),
    );
    _orders.insert(0, order);
    notifyListeners();
  }
}
