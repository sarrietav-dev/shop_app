import 'package:flutter/foundation.dart';
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
      "datetime": this.dateTime.toString(),
    };
  }
}

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  void addOrder(Cart order) {
    _orders.add(Order(
        id: DateTime.now().toString(),
        amount: order.totalAmount,
        products: order.items.values.toList(),
        dateTime: DateTime.now()));
    notifyListeners();
  }

  void clearOrders() {
    _orders = [];
    notifyListeners();
  }
}
