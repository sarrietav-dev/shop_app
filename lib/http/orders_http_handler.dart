import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app/http/check_status.dart';
import 'package:shop_app/http/http_request_handler.dart';
import 'package:shop_app/http/api_url_handler.dart';

class OrdersHttpHandler extends HTTPRequestHandler with StatusChecker {
  OrdersHttpHandler({body, resourceId})
      : super(body: body, resourceId: resourceId) {
    urlHandler = ApiUrlHandler(collectionName: "orders");
  }

  @override
  Future<http.Response> fetchData() async {
    final response = await http.get(urlHandler.url);
    checkStatus(response);
    return response;
  }

  Future<http.Response> addOrder() async {
    checkBody();
    final response = await http.post(urlHandler.url, body: json.encode(body));
    checkStatus(response);
    return response;
  }

  Future<http.Response> clear() async {
    final response = await http.patch(urlHandler.url, body: json.encode({}));
    checkStatus(response);
    return response;
  }
}
