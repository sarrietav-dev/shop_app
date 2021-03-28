import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shop_app/http/url_handlers/api_url_handler.dart';

abstract class HTTPRequestHandler {
  ApiUrlHandler urlHandler;

  @protected
  final String resourceId;

  @protected
  final dynamic body;

  HTTPRequestHandler({this.resourceId, this.body});
  Future<Response> fetchData();

  @protected
  void checkResourceId() {
    if (resourceId == null) throw ArgumentError.notNull("resourceID");
  }

  @protected
  void checkBody() {
    if (body == null) throw ArgumentError.notNull("body");
  }
}
