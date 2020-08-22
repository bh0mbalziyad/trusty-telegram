import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/manage_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import './providers/orders_provider.dart';
import './providers/auth_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (ctx) => ProductsProvider(),
          update: (ctx, auth, previousProducts) {
            return previousProducts..setToken(auth.token);
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: (ctx) => OrdersProvider(),
          update: (ctx, auth, previousOrders) {
            return previousOrders..setToken(auth.token);
          },
        ),
        ChangeNotifierProvider.value(value: CartProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, child) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          debugShowCheckedModeBanner: false,
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductsOverviewScreen.routeName: (_) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
            CartScreen.routeName: (_) => CartScreen(),
            OrdersScreen.routeName: (_) => OrdersScreen(),
            ManageProductsScreen.routeName: (_) => ManageProductsScreen(),
            EditProductScreen.routeName: (_) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
