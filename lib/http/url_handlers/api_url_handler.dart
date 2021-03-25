import 'package:flutter/foundation.dart';
import 'package:shop_app/http/url_handlers/url_handler.dart';

class ApiUrlHandler extends UrlHandler {
  ApiUrlHandler({@required collectionName})
      : super(
            collectionName: collectionName,
            baseUrl: "flutter-meal-app-99b13-default-rtdb.firebaseio.com");
}
