import 'package:flutter/material.dart';
import 'package:shop_app/pages/product_management_page.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
              height: 150,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: Theme.of(context).accentColor,
              alignment: Alignment.centerLeft,
              child: Text(
                "Shopping Center",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white),
              )),
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home page"),
            onTap: () => Navigator.of(context).pushReplacementNamed("/"),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Manage Products"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ProductManagementPage.routeName),
          ),
        ],
      ),
    );
  }
}
