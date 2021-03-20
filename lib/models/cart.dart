import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop_app/models/interfaces/json_parsable.dart';
import 'package:shop_app/models/product.dart';
import 'package:http/http.dart' as http;

class CartItem implements JSONParsable {
  final String id;
  final String title;
  int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;
  void deleteOne() => quantity--;

  @override
  Map<String, Object> toJSON() {
    return {
      "id": id,
      "title": title,
      "quantity": quantity,
      "price": price,
    };
  }
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get productCount => _items.length;

  double get totalAmount {
    double total = 0;
    _items.forEach((key, value) {
      total += value.totalPrice;
    });
    return total;
  }

  void removeItem(String key) {
    _items.remove(key);
    notifyListeners();
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _incrementProductQuantity(product);
    } else {
      _addNewProduct(product);
    }
    notifyListeners();
  }

  void _incrementProductQuantity(Product product) {
    final url = Uri.https(
        "flutter-meal-app-99b13-default-rtdb.firebaseio.com", "/cart.json");

    _items.update(
        product.id,
        (value) => CartItem(
            id: value.id,
            title: value.title,
            price: value.price,
            quantity: value.quantity + 1));

    try {
      http.patch(url, body: json.encode(_parseCartItemsToJson()));
    } on Exception catch (error) {
      _items[product.id].deleteOne();
      throw error;
    }
  }

  void _addNewProduct(Product product) {
    final url = Uri.https(
        "flutter-meal-app-99b13-default-rtdb.firebaseio.com", "/cart.json");

    _items.putIfAbsent(
        product.id,
        () => CartItem(
            id: DateTime.now().toString(),
            title: product.title,
            price: product.price));

    try {
      http.patch(url, body: json.encode(_parseCartItemsToJson()));
    } catch (error) {
      _items.remove(product.id);
      throw error;
    }
  }

  Map<String, Map<String, dynamic>> _parseCartItemsToJson() {
    Map<String, Map<String, dynamic>> parsedData = {};
    _items.forEach((key, value) {
      parsedData[key] = value.toJSON();
    });
    return parsedData;
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void undoLastAddition(Product product) {
    if (!_items.containsKey(product.id)) return;
    if (_items[product.id].quantity > 1) {
      _items[product.id].deleteOne();
    } else {
      _items.remove(product.id);
    }
    notifyListeners();
  }
}
