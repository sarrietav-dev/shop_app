import 'dart:convert';
import 'dart:io';

import 'package:shop_app/http/check_status.dart';
import 'package:shop_app/http/http_request_handler.dart';
import 'package:shop_app/http/url_handler.dart';
import 'package:http/http.dart' as http;

class ProductListingHTTPHandler
    with StatusChecker
    implements HTTPRequestHandler {
  URLHandler urlHandler;
  final String resourceId;
  final dynamic body;

  ProductListingHTTPHandler({this.body, this.resourceId}) {
    urlHandler = URLHandler(collectionName: "products");
  }

  @override
  Future<http.Response> fetchData() async {
    final response = await http.get(urlHandler.url);
    checkStatus(response);

    return response;
  }

  Future<http.Response> addProduct() async {
    _checkBody();

    final response = await http.post(urlHandler.url, body: json.encode(body));
    checkStatus(response);

    return response;
  }

  Future<http.Response> updateProduct() async {
    _checkResourceId();
    _checkBody();

    final response = await http.patch(urlHandler.getResourceUrl(resourceId),
        body: json.encode(body));
    checkStatus(response);

    return response;
  }

  Future<http.Response> deleteProduct() async {
    _checkResourceId();

    final response = await http.delete(urlHandler.getResourceUrl(resourceId));
    checkStatus(response);

    return response;
  }

  void _checkResourceId() {
    if (resourceId == null) throw ArgumentError.notNull("resourceID");
  }

  void _checkBody() {
    if (body == null) throw ArgumentError.notNull("body");
  }
}
