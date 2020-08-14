import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "dart:math";

import "../providers/orders_provider.dart" show Order;

class OrderItem extends StatefulWidget {
  final Order order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool isWidgetExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.orderTime)),
            trailing: IconButton(
              icon: Icon(
                  isWidgetExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  isWidgetExpanded = !isWidgetExpanded;
                });
              },
            ),
          ),
          if (isWidgetExpanded)
            Container(
              padding: const EdgeInsets.all(8),
              height: min(widget.order.products.length * 20.0 + 10, 180),
              child: ListView(
                children: widget.order.products
                    .map((product) => Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${product.quantity} x \$${product.price}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
