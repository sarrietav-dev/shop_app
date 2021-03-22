import 'package:flutter/foundation.dart';

class URLHandler {
  static const baseUrl = "flutter-meal-app-99b13-default-rtdb.firebaseio.com";
  final String collectionName;

  URLHandler({@required this.collectionName});

  get url => Uri.https(baseUrl, "/$collectionName.json");

  Uri getResourceUrl(String resourceId) {
    return Uri.https(baseUrl, "$collectionName/$resourceId.json");
  }
}
