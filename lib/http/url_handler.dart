import 'package:flutter/foundation.dart';

class URLHandler {
  static const baseUrl = "flutter-meal-app-99b13-default-rtdb.firebaseio.com";
  final String collectionResourceRoute;
  String singleResourceRoute;

  URLHandler({@required this.collectionResourceRoute});

  get url => Uri.https(baseUrl, "$collectionResourceRoute.json");

  Uri getResourceUrl(String resourceId) {
    return Uri.https(baseUrl, "$collectionResourceRoute/$resourceId.json");
  }
}
