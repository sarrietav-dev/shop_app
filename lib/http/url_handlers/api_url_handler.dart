import 'package:flutter/foundation.dart';
import 'package:shop_app/models/auth.dart';

class ApiUrlHandler extends ChangeNotifier {
  @protected
  static const String baseUrl =
      "flutter-meal-app-99b13-default-rtdb.firebaseio.com";
  @protected
  final String collectionName;
  @protected
  final bool excludeUser;

  ApiUrlHandler({
    @required this.collectionName,
    this.excludeUser = false,
  });

  get url {
    return Uri.https(
        baseUrl, "$_userIdRoute/$collectionName.json", _tokenUrlArg);
  }

  Uri getResourceUrl(String resourceId) {
    return Uri.https(
        baseUrl, "$_userIdRoute$collectionName/$resourceId.json", _tokenUrlArg);
  }

  String get _userIdRoute => excludeUser ? "" : "/${Auth.authInfo.localId}";

  static Map<String, String> get _tokenUrlArg => {
        "auth": Auth.authInfo.idToken,
      };
}
