import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/cart_provider.dart" show CartProvider;
import "../providers/orders_provider.dart" show OrdersProvider;
import "../widgets/cart_item.dart";
// import "../models/http_exceptions.dart";

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    // final scaffold = Scaffold.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          totalCostWidget(context, cart),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: cartItemsListWidget(cart),
          ),
        ],
      ),
    );
  }

  Widget cartItemsListWidget(CartProvider cart) {
    return ListView.builder(
      itemBuilder: (_, index) {
        final cartItem = cart.items.values.toList()[index];
        final productId = cart.items.keys.toList()[index];
        return CartItem(
          id: cartItem.id,
          productId: productId,
          price: cartItem.price,
          quantity: cartItem.quantity,
          title: cartItem.title,
        );
      },
      itemCount: cart.itemCount,
    );
  }

  Widget totalCostWidget(BuildContext context, CartProvider cart) {
    // final scaffold = Scaffold.of(context);
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Spacer(),
            Chip(
              label: Text(
                '\$${cart.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.headline6.color),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            OrderButton(),
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  // final ScaffoldState scaffold;

  // OrderButton(this.scaffold);

  const OrderButton({
    Key key,
  }) : super(key: key);

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return FlatButton(
      disabledTextColor: Colors.grey,
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
      onPressed: (cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await Provider.of<OrdersProvider>(context, listen: false)
                    .addOrder(cart.items.values.toList(), cart.totalAmount);
                cart.clearCart();
              } catch (error) {
                print('Failed to place order.\n${error.toString()}');
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            },
    );
  }
}
