import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import '../providers/products_provider.dart';

import '../widgets/products_grid.dart';

enum PopUpMenuSelectedItem {
  OnlyFavorites,
  ShowAll,
}

class ProductsOverviewScreen extends StatelessWidget {
  static const String routeName = "/products-overview";

  @override
  Widget build(BuildContext context) {
    final productContainer =
        Provider.of<ProductsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (selectedValue) {
              switch (selectedValue) {
                case PopUpMenuSelectedItem.OnlyFavorites:
                  productContainer.showFavorites();
                  break;
                case PopUpMenuSelectedItem.ShowAll:
                  productContainer.showAll();
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
      body: ProductsGrid(),
    );
  } //build

} //ProductsOverviewScreen
