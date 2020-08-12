import 'package:flutter/material.dart';
import "package:provider/provider.dart";

import '../providers/cart_provider.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import '../screens/cart_screen.dart';

enum PopUpMenuSelectedItem {
  OnlyFavorites,
  ShowAll,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const String routeName = "/products-overview";

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavorites = false;

  @override
  Widget build(BuildContext context) {
    // final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (selectedValue) {
              switch (selectedValue) {
                case PopUpMenuSelectedItem.OnlyFavorites:
                  setState(() {
                    _showFavorites = true;
                  });
                  break;
                case PopUpMenuSelectedItem.ShowAll:
                  setState(() {
                    _showFavorites = false;
                  });
                  break;
                default:
                  return;
              }
            },
            icon: Icon(Icons.more_vert_rounded),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only favorites'),
                value: PopUpMenuSelectedItem.OnlyFavorites,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: PopUpMenuSelectedItem.ShowAll,
              )
            ],
          ),
          Consumer<CartProvider>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      // backgroundColor: ,
      body: ProductsGrid(_showFavorites),
    );
  }
} //ProductsOverviewScreen
