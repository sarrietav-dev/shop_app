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

class CartItemBuilder {
  String id;
  String title;
  int quantity;
  double price;

  CartItemBuilder({this.id, this.title, this.quantity, this.price});

  CartItemBuilder.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    title = data["title"];
    quantity = data["quantity"];
    price = data["price"];
  }

  CartItem build() =>
      CartItem(id: id, title: title, price: price, quantity: quantity);
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

  Future<void> fetchItems() async {
    final url = Uri.https(
        "flutter-meal-app-99b13-default-rtdb.firebaseio.com", "/cart.json");
    final response = await http.get(url);
    _setFetchedItems(json.decode(response.body) as Map<String, dynamic>);
  }

  void _setFetchedItems(Map<String, dynamic> data) {
    Map<String, CartItem> _items = {};
    data.forEach((key, value) {
      _items[key] = CartItemBuilder.fromJson(value).build();
    });
  }

  void removeItem(String key) {
    final url = Uri.https("flutter-meal-app-99b13-default-rtdb.firebaseio.com",
        "/cart/$key.json");
    final removedItem = _items.remove(key);

    try {
      http.delete(url);
    } on Exception catch (error) {
      _items[key] = removedItem;
      throw error;
    } finally {
      notifyListeners();
    }
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _incrementProductQuantity(product);
    } else {
      _addNewProduct(product);
    }
    fetchItems(); // To always have the Firebase key stored.
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
            id: product.id, title: product.title, price: product.price));

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
    final url = Uri.https(
        "flutter-meal-app-99b13-default-rtdb.firebaseio.com", "/cart.json");
    final deletedMap = _items;
    _items = {};
    try {
      http.delete(url);
    } on Exception catch (e) {
      _items = deletedMap;
      throw e;
    } finally {
      notifyListeners();
    }
  }

  Future<void> undoLastAddition(Product product) async {
    final productLookup =
        _items.values.firstWhere((element) => element.id == product.id);
    if (productLookup == null) return;

    final key =
        _items.keys.firstWhere((element) => _items[element] == productLookup);

    if (_items[key].quantity > 1) {
      await _deleteOneProductQuantity(product);
    } else {
      this.removeItem(key);
    }
    notifyListeners();
  }

  Future<void> _deleteOneProductQuantity(Product product) async {
    final url = Uri.https("flutter-meal-app-99b13-default-rtdb.firebaseio.com",
        "/cart/${product.id}.json");

    _items[product.id].deleteOne();

    try {
      await http.patch(url, body: json.encode(product.toJSON()));
    } on Exception catch (e) {
      _items[product.id].quantity++;
      throw e;
    } finally {
      notifyListeners();
    }
  }
}
