import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/orders.dart';
import 'package:shop_app/pages/auth_page.dart';
import 'package:shop_app/pages/cart_page.dart';
import 'package:shop_app/pages/edit_product_page.dart';
import 'package:shop_app/pages/product_detail_page.dart';
import 'package:shop_app/models/product_listing.dart';
import 'package:shop_app/pages/tabs_page.dart';
import 'package:shop_app/pages/product_management_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductListing(),
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Orders()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: "Lato",
        ),
        routes: {
          "/": (_) => AuthPage(),
          TabsPage.routeName: (_) => TabsPage(),
          ProductDetailPage.routeName: (_) => ProductDetailPage(),
          CartPage.routeName: (_) => CartPage(),
          ProductManagementPage.routeName: (_) => ProductManagementPage(),
          EditProductPage.routeName: (_) => EditProductPage(),
        },
      ),
    );
  }
}
