import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/orders_provider.dart" show OrdersProvider;
import "../widgets/order_item.dart";
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      drawer: AppDrawer(),
      // Very important concept right here
      body: FutureBuilder(
          future: Provider.of<OrdersProvider>(context, listen: false)
              .fetchAndSetOrders(),
          builder: (ctx, currentData) {
            if (currentData.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            if (currentData.hasError) {
              print('Error');
              return Center(child: Text('There was an error'));
            }
            return Consumer<OrdersProvider>(
                builder: (ctx, ordersProvider, child) {
              return ListView.builder(
                itemCount: ordersProvider.orders.length,
                itemBuilder: (_, index) =>
                    OrderItem(ordersProvider.orders[index]),
              );
            });
          }),
    );
  }
}
