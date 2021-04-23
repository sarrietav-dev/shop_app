import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app/http/check_status.dart';
import 'package:shop_app/http/api_handlers/http_request_handler.dart';
import 'package:shop_app/http/url_handlers/api_url_handler.dart';

class CartHttpHandler extends HTTPRequestHandler with StatusChecker {
  @override
  ApiUrlHandler urlHandler;

  CartHttpHandler({resourceId, body})
      : super(resourceId: resourceId, body: body) {
    urlHandler = ApiUrlHandler(collectionName: "cart");
  }

  @override
  Future<http.Response> fetchData() async {
    final response = await http.get(urlHandler.url);
    checkStatus(response);
    return response;
  }

  Future<http.Response> removeItem() async {
    checkResourceId();
    final response = await http.delete(urlHandler.getResourceUrl(resourceId));
    checkStatus(response);
    return response;
  }

  Future<http.Response> update() async {
    checkBody();
    final response = await http.patch(urlHandler.url, body: json.encode(body));
    checkStatus(response);
    return response;
  }

  Future<http.Response> clear() async {
    final response = await http.delete(urlHandler.url);
    checkStatus(response);
    return response;
  }
}
