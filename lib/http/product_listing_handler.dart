import 'dart:convert';

import 'package:shop_app/http/check_status.dart';
import 'package:shop_app/http/http_request_handler.dart';
import 'package:shop_app/http/url_handler.dart';
import 'package:http/http.dart' as http;

class ProductListingHTTPHandler extends HTTPRequestHandler with StatusChecker {
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
    checkBody();

    final response = await http.post(urlHandler.url, body: json.encode(body));
    checkStatus(response);

    return response;
  }

  Future<http.Response> updateProduct() async {
    checkResourceId();
    checkBody();

    final response = await http.patch(urlHandler.getResourceUrl(resourceId),
        body: json.encode(body));
    checkStatus(response);

    return response;
  }

  Future<http.Response> deleteProduct() async {
    checkResourceId();

    final response = await http.delete(urlHandler.getResourceUrl(resourceId));
    checkStatus(response);

    return response;
  }
}
