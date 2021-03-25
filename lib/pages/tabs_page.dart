import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/product_listing.dart';
import 'package:shop_app/pages/cart_page.dart';
import 'package:shop_app/pages/drawer.dart';
import 'package:shop_app/pages/orders_page.dart';
import 'package:shop_app/pages/products_overview_page.dart';
import 'package:shop_app/widgets/badge.dart';

class TabsPage extends StatefulWidget {
  static const routeName = "/home";
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  var _showFavourites = false;

  void handleSelectFavourites(MenuOptions value, ProductListing products) {
    setState(() {
      switch (value) {
        case MenuOptions.ShowFavourites:
          _showFavourites = true;
          break;
        case MenuOptions.ShowAll:
          _showFavourites = false;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: MainDrawer(),
          appBar: AppBar(
            title: const Text("Shop"),
            actions: [
              _PopupMenu(
                onSelected: handleSelectFavourites,
              ),
              _CartIcon(),
            ],
          ),
          bottomNavigationBar: Material(
            color: Theme.of(context).primaryColor,
            child: TabBar(tabs: [
              const Tab(
                icon: Icon(Icons.shop),
                child: Text("Items"),
              ),
              const Tab(
                icon: Icon(Icons.credit_card),
                child: Text("Orders"),
              )
            ]),
          ),
          body: TabBarView(children: [
            ProductsOverviewPage(
              showFavourites: _showFavourites,
            ),
            OrdersPage()
          ]),
        ));
  }
}

enum MenuOptions {
  ShowFavourites,
  ShowAll,
}

class _PopupMenu extends StatelessWidget {
  final Function onSelected;

  const _PopupMenu({
    Key key,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductListing>(context, listen: false);

    return PopupMenuButton(
        icon: const Icon(Icons.more_vert),
        onSelected: (value) => onSelected(value, products),
        itemBuilder: (context) => [
              const PopupMenuItem(
                child: const Text("Only Favourites"),
                value: MenuOptions.ShowFavourites,
              ),
              const PopupMenuItem(
                child: const Text("Show All"),
                value: MenuOptions.ShowAll,
              ),
            ]);
  }
}

class _CartIcon extends StatelessWidget {
  const _CartIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (_, cart, child) =>
          Badge(child: child, value: cart.productCount.toString()),
      child: IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () => Navigator.of(context).pushNamed(CartPage.routeName)),
    );
  }
}
