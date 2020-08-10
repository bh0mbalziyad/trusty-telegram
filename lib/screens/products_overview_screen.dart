import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

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
        ],
      ),
      // backgroundColor: ,
      body: ProductsGrid(_showFavorites),
    );
  }
} //ProductsOverviewScreen
