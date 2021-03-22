import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop_app/http/orders_http_handler.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/interfaces/json_parsable.dart';

mixin Expandable {
  bool isExpanded = false;
}

class Order with Expandable implements JSONParsable {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  Order(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});

  @override
  Map<String, Object> toJSON() {
    return {
      "id": this.id,
      "amount": this.amount,
      "products": products.map((e) => e.toJSON()).toList(),
      "dateTime": this.dateTime.toString(),
    };
  }
}

class OrderBuilder {
  String id;
  double amount;
  List<CartItem> products;
  DateTime dateTime;

  OrderBuilder.json(Map<String, dynamic> data) {
    id = data["id"];
    amount = data["amount"];
    dateTime = DateTime.parse(data["dateTime"]);
    products = (data["products"] as List<Map<String, dynamic>>)
        .map((e) => CartItemBuilder.fromJson(e).build())
        .toList();
  }

  Order build() {
    return Order(
        id: id, amount: amount, products: products, dateTime: dateTime);
  }
}

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchData() async {
    final response = await OrdersHttpHandler().fetchData();
    final data = json.decode(response.body);
    _setOrders = data;
    notifyListeners();
  }

  set _setOrders(List<Map<String, dynamic>> data) {
    _orders = [];
    if (data == null) return;
    _orders = data.map((e) => OrderBuilder.json(e).build()).toList();
  }

  Future<void> addOrder(Cart order) async {
    _orders.add(Order(
        id: DateTime.now().toString(),
        amount: order.totalAmount,
        products: order.items.values.toList(),
        dateTime: DateTime.now()));

    try {
      await OrdersHttpHandler(body: _orders.last.toJSON()).addOrder();
    } on Exception catch (e) {
      _orders.removeLast();
      throw e;
    } finally {
      notifyListeners();
    }
  }

  Future<void> clearOrders() async {
    await OrdersHttpHandler().clear();
    _orders = [];
    notifyListeners();
  }
}
