import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../providers/orders_provider.dart" show Order;

class OrderItem extends StatelessWidget {
  final Order order;
  OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${order.amount}'),
            subtitle:
                Text(DateFormat('dd/MM/yyyy hh:mm').format(order.orderTime)),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
