import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app/http/api_handlers/http_request_handler.dart';
import 'package:shop_app/http/check_status.dart';
import 'package:shop_app/http/url_handlers/api_url_handler.dart';

class FavouritesHttpHandler extends HTTPRequestHandler with StatusChecker {
  FavouritesHttpHandler({body, resourceId})
      : super(body: body, resourceId: resourceId) {
    urlHandler = ApiUrlHandler(collectionName: "userFavourites");
  }

  @override
  Future<http.Response> fetchData() async {
    final response = await http.get(urlHandler.url);
    checkStatus(response);
    return response;
  }

  Future<http.Response> toggleFavourite() async {
    checkBody();
    checkResourceId();
    final response = await http.patch(urlHandler.getResourceUrl(resourceId),
        body: json.encode(body));
    checkStatus(response);
    return response;
  }
}
