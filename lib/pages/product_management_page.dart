import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/models/product_listing.dart';
import 'package:shop_app/pages/drawer.dart';
import 'package:shop_app/pages/edit_product_page.dart';
import 'package:shop_app/utils/show_error_dialog.dart';

class ProductManagementPage extends StatefulWidget {
  static const routeName = "/product-management";

  @override
  _ProductManagementPageState createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage>
    with ErrorDialog {
  bool _isLoading = false;

  void useSpinner(Future Function() callback) {
    setState(() {
      _isLoading = true;
    });

    callback()
        .catchError(
            (error) => showErrorDialog(context, message: error.toString()))
        .then((value) => setState(() {
              _isLoading = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text("Manage products"),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductPage.routeName))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: const CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Consumer<ProductListing>(
                  builder: (context, products, child) => ListView.builder(
                      itemCount: products.items.length,
                      itemBuilder: (context, index) => Column(
                            children: [
                              _UserProductItem(
                                product: products.items[index],
                                useSpinner: useSpinner,
                              ),
                              const Divider(),
                            ],
                          ))),
            ),
    );
  }
}

class _UserProductItem extends StatelessWidget {
  const _UserProductItem({
    Key key,
    this.product,
    this.useSpinner,
  }) : super(key: key);

  final Product product;
  final Function useSpinner;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.of(context)
                  .pushNamed(EditProductPage.routeName, arguments: product),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => showDeletionWarningDialog(context),
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }

  Future showDeletionWarningDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Are you sure you want to delete this?"),
              content: const Text("This can't be undone"),
              actions: [
                TextButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Text("No")),
                TextButton(
                    onPressed: () {
                      useSpinner(() =>
                          Provider.of<ProductListing>(context, listen: false)
                              .deleteProduct(product));
                      Navigator.of(context).pop();
                    },
                    child: const Text("Yes")),
              ],
            ));
  }
}
