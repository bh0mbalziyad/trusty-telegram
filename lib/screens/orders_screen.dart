import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/orders_provider.dart" show OrdersProvider;
import "../widgets/order_item.dart";
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = false;
  @override
  initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<OrdersProvider>(context, listen: false)
        .fetchAndSetOrders()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ordersProvider.orders.length,
              itemBuilder: (_, index) =>
                  OrderItem(ordersProvider.orders[index]),
            ),
    );
  }
}
