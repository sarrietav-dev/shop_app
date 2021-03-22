import 'dart:convert';
import 'dart:io';

import 'package:shop_app/http/http_request_handler.dart';
import 'package:shop_app/http/url_handler.dart';
import 'package:http/http.dart' as http;

class ProductListingHTTPHandler implements HTTPRequestHandler {
  URLHandler urlHandler;
  final String resourceId;
  final dynamic body;

  ProductListingHTTPHandler({this.body, this.resourceId}) {
    urlHandler = URLHandler(collectionName: "products");
  }

  @override
  Future<http.Response> fetchData() async {
    return await http.get(urlHandler.url);
  }

  Future<http.Response> addProduct() async {
    _checkBody();
    return http.post(urlHandler.url, body: json.encode(body));
  }

  Future<http.Response> updateProduct() async {
    _checkResourceId();
    _checkBody();
    return await http.patch(urlHandler.getResourceUrl(resourceId),
        body: json.encode(body));
  }

  Future<http.Response> deleteProduct() async {
    _checkResourceId();
    final response = await http.delete(urlHandler.getResourceUrl(resourceId));

    if (response.statusCode >= 400)
      throw HttpException("Could not delete product");
  }

  void _checkResourceId() {
    if (resourceId == null) throw ArgumentError.notNull("resourceID");
  }

  void _checkBody() {
    if (body == null) throw ArgumentError.notNull("body");
  }
}
