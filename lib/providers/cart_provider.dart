import "package:flutter/foundation.dart";

class Cart {
  final String id;
  final String title;
  final int quantity;
  final double price;

  Cart({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, Cart> _items;

  Map<String, Cart> get items {
    return {..._items};
  }

  int get itemCount {
    if (_items == null) return 0;
    return _items.length;
  }

  // TODO: Fix this function
  void addItemToCart({
    @required String productId,
    @required double price,
    @required String title,
  }) {
    if (_items == null) {
      _items.putIfAbsent(
          productId,
          () => Cart(
                id: DateTime.now().toString(),
                title: title,
                quantity: 1,
                price: price,
              ));
      notifyListeners();
    }
    if (_items.containsKey(productId)) {
      // increase quantity
      _items.update(
          productId,
          (existingCartItem) => Cart(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity + 1,
              ));
      notifyListeners();
      return;
    }
  }
}
