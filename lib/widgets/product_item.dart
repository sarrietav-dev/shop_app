import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/pages/product_detail_page.dart';
import 'package:shop_app/utils/show_error_dialog.dart';

class ProductItem extends StatelessWidget {
  void handleTap(BuildContext context, Product product) => Navigator.of(context)
      .pushNamed(ProductDetailPage.routeName, arguments: {"product": product});

  @override
  Widget build(BuildContext context) {
    return Consumer<Product>(
      builder: (context, product, child) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
              onTap: () => handleTap(context, product),
              child: Image.network(product.imageUrl, fit: BoxFit.cover)),
          footer: _ProductItemFooter(product: product),
        ),
      ),
    );
  }
}

class _ProductItemFooter extends StatefulWidget {
  _ProductItemFooter({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  __ProductItemFooterState createState() => __ProductItemFooterState();
}

class __ProductItemFooterState extends State<_ProductItemFooter>
    with ErrorDialog {
  bool _isFavouriteLoading = false;

  Widget build(BuildContext context) {
    return GridTileBar(
      backgroundColor: Colors.black87,
      leading: _isFavouriteLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : IconButton(
              icon: Icon(
                widget.product.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_outline,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () async {
                setState(() {
                  _isFavouriteLoading = true;
                });

                try {
                  await widget.product.toggleFavouriteStatus();
                } catch (error) {
                  showErrorDialog(context);
                } finally {
                  setState(() {
                    _isFavouriteLoading = false;
                  });
                }
              }),
      title: Text(
        widget.product.title,
        textAlign: TextAlign.center,
      ),
      trailing: Consumer<Cart>(
        builder: (context, cart, child) => IconButton(
            icon: Icon(
              Icons.add_shopping_cart,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              cart.addItem(widget.product);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 2),
                content: Text("Item added to the cart!"),
                action: SnackBarAction(
                    label: "Undo",
                    onPressed: () => cart.undoLastAddition(widget.product)),
              ));
            }),
      ),
    );
  }
}
