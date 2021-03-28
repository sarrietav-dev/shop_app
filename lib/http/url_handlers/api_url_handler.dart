import 'package:flutter/foundation.dart';
import 'package:shop_app/models/auth.dart';

class ApiUrlHandler extends ChangeNotifier {
  @protected
  static const String baseUrl =
      "flutter-meal-app-99b13-default-rtdb.firebaseio.com";
  @protected
  final String collectionName;

  ApiUrlHandler({@required this.collectionName});

  get url {
    return Uri.https(baseUrl, "/$collectionName.json", _tokenUrlArg);
  }

  Uri getResourceUrl(String resourceId) {
    return Uri.https(baseUrl, "$collectionName/$resourceId.json", _tokenUrlArg);
  }

  static Map<String, String> get _tokenUrlArg => {
        "auth": Auth.authInfo.idToken,
      };
}
