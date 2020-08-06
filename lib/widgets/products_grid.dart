import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import './product_item.dart';

import '../providers/products_provider.dart';

class ProductsGrid extends StatelessWidget {
  // List<Product> loadedProducts;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    var loadedProducts = productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: loadedProducts.length,
      itemBuilder: (context, index) {
        final Product product = loadedProducts[index];
        return ProductItem(
          id: product.id,
          imageUrl: product.imageUrl,
          title: product.title,
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // minimum number of columns in grid
        childAspectRatio:
            3 / 2, // height to width ratio of each item in the grid view
        crossAxisSpacing: 10, // spacing between columns
        mainAxisSpacing: 10, // spacing between rows
      ),
    );
  }
}
