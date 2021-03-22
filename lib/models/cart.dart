import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop_app/http/cart_http_handler.dart';
import 'package:shop_app/models/interfaces/json_parsable.dart';
import 'package:shop_app/models/product.dart';

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
    final response = await CartHttpHandler().fetchData();
    final data = await json.decode(response.body);
    _setFetchedItems(data as Map<String, dynamic>);
  }

  void _setFetchedItems(Map<String, dynamic> data) {
    _items = {};
    if (data == null) return;
    data.forEach((key, value) {
      _items[key] = CartItemBuilder.fromJson(value).build();
    });
  }

  Future<void> removeItem(String key) async {
    await CartHttpHandler(resourceId: key).removeItem();
    notifyListeners();
  }

  Future<void> addItem(Product product) async {
    if (_items.containsKey(product.id)) {
      await _incrementProductQuantity(product);
    } else {
      await _addNewProduct(product);
    }
    await fetchItems(); // To always have the Firebase key stored.

    notifyListeners();
  }

  Future<void> _incrementProductQuantity(Product product) async {
    _items.update(
        product.id,
        (value) => CartItem(
            id: value.id,
            title: value.title,
            price: value.price,
            quantity: value.quantity + 1));

    try {
      await CartHttpHandler(body: _parseCartItemsToJson()).update();
    } catch (error) {
      _items[product.id].deleteOne();
      throw error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> _addNewProduct(Product product) async {
    _items.putIfAbsent(
        product.id,
        () => CartItem(
            id: product.id, title: product.title, price: product.price));

    try {
      await CartHttpHandler(body: _parseCartItemsToJson()).update();
    } catch (error) {
      _items.remove(product.id);
      throw error;
    } finally {
      notifyListeners();
    }
  }

  Map<String, Map<String, dynamic>> _parseCartItemsToJson() {
    Map<String, Map<String, dynamic>> parsedData = {};
    _items.forEach((key, value) {
      parsedData[key] = value.toJSON();
    });
    return parsedData;
  }

  Future<void> clear() async {
    await CartHttpHandler(body: {}).update();
    _items = {};
    notifyListeners();
  }

  Future<void> undoLastAddition(Product product) async {
    final productLookup = _items.values
        .firstWhere((element) => element.id == product.id, orElse: () => null);
    if (productLookup == null) return;

    final key =
        _items.keys.firstWhere((element) => _items[element] == productLookup);

    if (_items[key].quantity > 1) {
      await _deleteOneProductQuantity(product);
    } else {
      await removeItem(key);
    }
    notifyListeners();
  }

  Future<void> _deleteOneProductQuantity(Product product) async {
    await CartHttpHandler(
            resourceId: product.id, body: _items[product.id].toJSON())
        .update();
    _items[product.id].deleteOne();
    notifyListeners();
  }
}
