import 'package:flutter/foundation.dart';

class ApiUrlHandler {
  @protected
  static const String baseUrl =
      "flutter-meal-app-99b13-default-rtdb.firebaseio.com";
  @protected
  final String collectionName;

  ApiUrlHandler({@required this.collectionName});

  get url => Uri.https(baseUrl, "/$collectionName.json");

  Uri getResourceUrl(String resourceId) {
    return Uri.https(baseUrl, "$collectionName/$resourceId.json");
  }
}
