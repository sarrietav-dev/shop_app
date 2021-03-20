import 'package:flutter/material.dart';
import 'package:shop_app/models/cart.dart';

class ProductListItem extends StatelessWidget {
  const ProductListItem({
    Key key,
    @required this.cartItem,
    this.hasMargin = false,
  }) : super(key: key);

  final CartItem cartItem;
  final bool hasMargin;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin:
          hasMargin ? EdgeInsets.symmetric(horizontal: 15, vertical: 4) : null,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(child: Text("\$${cartItem.price}")),
            ),
          ),
          title: Text(cartItem.title),
          subtitle: Text("Total: \$${cartItem.totalPrice.toStringAsFixed(2)}"),
          trailing: Text("${cartItem.quantity} x"),
        ),
      ),
    );
  }
}
