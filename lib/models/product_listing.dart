import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/http/api_handlers/favourites_http_handler.dart';
import 'package:shop_app/http/api_handlers/product_listing_handler.dart';
import 'package:shop_app/models/product.dart';

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
    _setProducts = json.decode(response.body) as Map<String, dynamic>;
  }

  set _setProducts(Map<String, dynamic> data) {
    _items = [];

    Map<String, dynamic> userFavourites;
    _getFavourites.then((value) => userFavourites = value);

    data.forEach((key, value) {
      UserFavouriteData userFavouriteData =
          _getFavouriteData(userFavourites, key);

      _items.add(ProductBuilder.json(id: key, data: value)
          .setIsFavourite(userFavouriteData)
          .build());
    });
    notifyListeners();
  }

  Future<Map<String, dynamic>> get _getFavourites async {
    final response = await FavouritesHttpHandler().fetchData();
    return json.decode(response.body);
  }

  UserFavouriteData _getFavouriteData(
      Map<String, dynamic> userFavourites, String key) {
    if (userFavourites == null)
      return UserFavouriteData(
          id: DateTime.now().toString(), isFavourite: false, productId: key);

    final favouritedProduct = userFavourites.entries
        .firstWhere((element) => element.value["productId"] == key);
    return UserFavouriteData(
        id: favouritedProduct.key,
        isFavourite: favouritedProduct.value["isFavourite"],
        productId: key);
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
