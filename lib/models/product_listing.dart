import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';
import 'package:http/http.dart' as http;

class ProductListing with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.https(
        "flutter-meal-app-99b13-default-rtdb.firebaseio.com", "/products.json");

    final response = await http.post(url, body: json.encode(product.toJSON()));

    _items.add(ProductBuilder.existing(product)
        .setId(json.decode(response.body)["id"].toString())
        .build());
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    final url = Uri.https(
        "flutter-meal-app-99b13-default-rtdb.firebaseio.com", "/products.json");
    final response = await http.get(url);
    final data = json.decode(response.body) as Map<String, dynamic>;
    _setProductsFromJson(data);
  }

  // FIXME: Unhandled Exception: type 'String' is not a subtype of type 'Map<String, dynamic>'
  void _setProductsFromJson(Map<String, dynamic> data) {
    _items = [];
    data.forEach((key, value) {
      _items.add(ProductBuilder.json(id: key, data: value).build());
    });
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final url = Uri.https("flutter-meal-app-99b13-default-rtdb.firebaseio.com",
        "/products/${product.id}.json");
    await http.patch(url, body: json.encode(product.toJSON()));

    final lastIndex = _items.indexWhere((element) => element.id == product.id);
    _items.removeWhere((element) => element.id == product.id);
    _items.insert(lastIndex, product);
    notifyListeners();
  }

  Future<void> deleteProduct(Product product) async {
    final url = Uri.https("flutter-meal-app-99b13-default-rtdb.firebaseio.com",
        "/products/${product.id}.json");
    final response = await http.delete(url);
    if (response.statusCode >= 400)
      throw HttpException(message: "Could not delete product");
    _items.removeWhere((element) => product.id == element.id);

    notifyListeners();
  }
}

class HttpException implements Exception {
  final String message;

  HttpException({this.message});

  @override
  String toString() {
    return message;
  }
}
