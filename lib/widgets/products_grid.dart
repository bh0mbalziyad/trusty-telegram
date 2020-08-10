import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import './product_item.dart';

import '../providers/products_provider.dart';

class ProductsGrid extends StatelessWidget {
  // List<Product> loadedProducts;
  final bool showFavorites;
  ProductsGrid(this.showFavorites);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    var loadedProducts =
        showFavorites ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: loadedProducts.length,
      itemBuilder: (context, index) {
        final Product product = loadedProducts[index];
        return ChangeNotifierProvider.value(
          value: product,
          child: ProductItem(),
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
  } // build
} // ProductsGrid
