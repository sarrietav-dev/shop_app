import 'package:flutter/material.dart';
import 'package:shop_app/pages/product_management_page.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const _DrawerBanner(),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home page"),
            onTap: () => Navigator.of(context).pushReplacementNamed("/"),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Manage Products"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ProductManagementPage.routeName),
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}

class _DrawerBanner extends StatelessWidget {
  const _DrawerBanner({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        color: Theme.of(context).accentColor,
        alignment: Alignment.centerLeft,
        child: const Text(
          "Shopping Center",
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white),
        ));
  }
}
