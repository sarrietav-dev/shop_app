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
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context).orders;
    return Scaffold(
      body: SingleChildScrollView(
        child: ExpansionPanelList(
            expansionCallback: (index, isExpanded) {
              setState(() {
                orders[index].isExpanded = !isExpanded;
              });
            },
            children: orders
                .map<ExpansionPanel>((order) => ExpansionPanel(
                    isExpanded: order.isExpanded,
                    headerBuilder: (context, isExpanded) => Container(
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
                            subtitle:
                                Text(DateFormat.yMMMd().format(order.dateTime)),
                          ),
                        ),
                    body: Container(
                      height: 200,
                      child: ListView.builder(
                          itemCount: order.products.length,
                          itemBuilder: (context, index) =>
                              ProductListItem(cartItem: order.products[index])),
                    )))
                .toList()),
      ),
    );
  }
}
