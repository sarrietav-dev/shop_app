import 'package:flutter/foundation.dart';

abstract class UrlHandler {
  @protected
  // static const baseUrl = "flutter-meal-app-99b13-default-rtdb.firebaseio.com";
  final String baseUrl;
  @protected
  final String collectionName;

  UrlHandler({@required this.collectionName, @required this.baseUrl});

  get url => Uri.https(baseUrl, "/$collectionName.json");

  Uri getResourceUrl(String resourceId) {
    return Uri.https(baseUrl, "$collectionName/$resourceId.json");
  }
}
