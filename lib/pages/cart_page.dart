import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/orders.dart';
import 'package:shop_app/widgets/product_list_item.dart';

class CartPage extends StatefulWidget {
  static const routeName = "/cart";

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isFetched = false;
  bool _isLoading = false;

  @override
  void initState() {
    if (!_isFetched) {
      Provider.of<Cart>(context, listen: false).fetchItems();
      setState(() {
        _isFetched = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : Consumer<Cart>(
              child: const SizedBox(
                height: 10,
              ),
              builder: (_, cart, child) => Column(
                children: [
                  _CartOverview(cart: cart),
                  child,
                  Expanded(
                      child: ListView.builder(
                          itemCount: cart.productCount,
                          itemBuilder: (context, index) => _CartItem(
                                cartItemKey: cart.items.keys.toList()[index],
                                cartItem: cart.items.values.toList()[index],
                              )))
                ],
              ),
            ),
    );
  }
}

class _CartOverview extends StatelessWidget {
  const _CartOverview({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total",
              style: TextStyle(fontSize: 20),
            ),
            const Spacer(),
            Chip(
              label: Text(
                "\$${cart.totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            Consumer<Orders>(
              builder: (_, orders, child) => TextButton(
                onPressed: cart.items.isEmpty
                    ? null
                    : () {
                        orders.addOrder(cart);
                        cart.clear();
                      },
                child: child,
                style: ButtonStyle(foregroundColor:
                    MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.disabled))
                    return Colors.grey;
                  return Theme.of(context).primaryColor;
                })),
              ),
              child: Text(
                "ORDER NOW",
                style: TextStyle(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  const _CartItem({
    Key key,
    @required this.cartItem,
    @required this.cartItemKey,
  }) : super(key: key);

  final String cartItemKey;
  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return _DismissibleCartItem(
      key: ValueKey(cartItem.id),
      onDismissed: (direction) =>
          Provider.of<Cart>(context, listen: false).removeItem(cartItemKey),
      child: ProductListItem(
        cartItem: cartItem,
        hasMargin: true,
      ),
    );
  }
}

class _DismissibleCartItem extends StatelessWidget {
  const _DismissibleCartItem({
    Key key,
    this.onDismissed,
    this.child,
  }) : super(key: key);

  final Function(DismissDirection direction) onDismissed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key,
      child: child,
      onDismissed: onDismissed,
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) =>
          showDialog(context: context, builder: (context) => _DismissAlert()),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(
          Icons.remove_shopping_cart_outlined,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}

class _DismissAlert extends StatelessWidget {
  const _DismissAlert({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Are you sure?"),
      content: Text("Do you want to remove the item from the cart?"),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("No")),
        TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Yes"))
      ],
    );
  }
}
