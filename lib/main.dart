import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/models/auth.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/orders.dart';
import 'package:shop_app/pages/auth_page.dart';
import 'package:shop_app/pages/cart_page.dart';
import 'package:shop_app/pages/edit_product_page.dart';
import 'package:shop_app/pages/product_detail_page.dart';
import 'package:shop_app/models/product_listing.dart';
import 'package:shop_app/pages/tabs_page.dart';
import 'package:shop_app/pages/product_management_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

void main() async {
  await DotEnv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProvider(
          create: (_) => ProductListing(),
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Orders()),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: "Lato",
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            }),
          ),
          routes: {
            "/": (_) => Auth.authInfo.isAuth
                ? TabsPage()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          if (snapshot.data) return TabsPage();
                          return const AuthPage();
                        default:
                          return Scaffold(
                            appBar: AppBar(),
                            body: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                      }
                    }),
            ProductDetailPage.routeName: (_) => ProductDetailPage(),
            CartPage.routeName: (_) => CartPage(),
            ProductManagementPage.routeName: (_) => ProductManagementPage(),
            EditProductPage.routeName: (_) => EditProductPage(),
          },
        ),
      ),
    );
  }
}
