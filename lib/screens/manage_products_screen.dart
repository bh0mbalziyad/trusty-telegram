import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/products_provider.dart";

import "../widgets/app_drawer.dart";
import "../widgets/manage_products_item.dart";

import "../screens/edit_product_screen.dart";

class ManageProductsScreen extends StatelessWidget {
  static const routeName = "/manage-products";

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mangage Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productProvider.items.length,
          itemBuilder: (ctx, index) {
            final product = productProvider.items[index];
            return Column(
              children: [
                ManageProductItem(product.id, product.title, product.imageUrl),
                Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
