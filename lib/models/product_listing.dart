import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/http/product_listing_handler.dart';
import 'package:shop_app/models/product.dart';
import 'package:http/http.dart' as http;

class ProductListing with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Future<void> addProduct(Product product) async {
    final response =
        await ProductListingHTTPHandler(body: product.toJSON()).addProduct();

    _items.add(ProductBuilder.existing(product)
        .setId(json.decode(response.body)["id"].toString())
        .build());
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    final response = await ProductListingHTTPHandler().fetchData();
    final data = json.decode(response.body) as Map<String, dynamic>;
    _setProductsFromJson(data);
  }

  void _setProductsFromJson(Map<String, dynamic> data) {
    _items = [];
    data.forEach((key, value) {
      _items.add(ProductBuilder.json(id: key, data: value).build());
    });
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    await ProductListingHTTPHandler(
            resourceId: product.id, body: product.toJSON())
        .updateProduct();

    final lastIndex = _items.indexWhere((element) => element.id == product.id);
    _items.removeWhere((element) => element.id == product.id);
    _items.insert(lastIndex, product);
    notifyListeners();
  }

  Future<void> deleteProduct(Product product) async {
    await ProductListingHTTPHandler(resourceId: product.id).deleteProduct();

    _items.removeWhere((element) => product.id == element.id);

    notifyListeners();
  }
}
