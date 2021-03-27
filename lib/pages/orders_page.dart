import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/orders.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/widgets/product_list_item.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isFetched = false;
  bool _isLoading = false;

  @override
  void initState() {
    if (!_isFetched) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Orders>(context, listen: false).fetchData().then((value) {
        setState(() {
          _isFetched = true;
          _isLoading = false;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Consumer<Orders>(
                  builder: (context, orders, child) => ExpansionPanelList(
                      expansionCallback: (index, isExpanded) {
                        setState(() {
                          orders.orders[index].isExpanded = !isExpanded;
                        });
                      },
                      children: orders.orders
                          .map<ExpansionPanel>((order) => ExpansionPanel(
                              isExpanded: order.isExpanded,
                              headerBuilder: (context, isExpanded) =>
                                  _ExpansionPanelHeader(
                                    order: order,
                                  ),
                              body: _ExpansionPanelBody(
                                order: order,
                              )))
                          .toList()),
                ),
              ));
  }
}

class _ExpansionPanelBody extends StatelessWidget {
  const _ExpansionPanelBody({
    Key key,
    this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
          itemCount: order.products.length,
          itemBuilder: (context, index) =>
              ProductListItem(cartItem: order.products[index])),
    );
  }
}

class _ExpansionPanelHeader extends StatelessWidget {
  const _ExpansionPanelHeader({
    Key key,
    this.order,
  }) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).accentColor,
          child: const Icon(
            Icons.shopping_basket,
            color: Colors.white,
          ),
        ),
        title: Text("\$${order.amount.toStringAsFixed(2)}"),
        subtitle: Text(DateFormat.yMMMd().format(order.dateTime)),
      ),
    );
  }
}
