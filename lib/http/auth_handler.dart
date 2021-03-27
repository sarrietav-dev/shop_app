import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/http/check_status.dart';
import 'package:shop_app/utils/auth_info.dart';
import 'package:shop_app/utils/credentials.dart';

class AuthHandler with StatusChecker {
  final url = Uri.https(
      "identitytoolkit.googleapis.com", "", {"key": env["FIREBASE_API_KEY"]});

  final Credential credential;

  AuthHandler(this.credential);

  Future<AuthInfo> signup() async {
    final response = await http.post(url.replace(path: "/v1/accounts:signUp"),
        body: json.encode(
            credential.toJSON..putIfAbsent("returnSecureToken", () => true)));
    checkStatus(response);

    final data = json.decode(response.body);

    return AuthInfo(
        idToken: data["idToken"],
        expiresIn: data["expiresIn"],
        localId: data["localId"]);
  }

  Future<AuthInfo> login() async {
    final response = await http.post(
        url.replace(path: "/v1/accounts:signInWithPassword"),
        body: json.encode(
            credential.toJSON..putIfAbsent("returnSecureToken", () => true)));
    checkStatus(response);

    final data = json.decode(response.body);

    return AuthInfo(
        idToken: data["idToken"],
        expiresIn: data["expiresIn"],
        localId: data["localId"]);
  }
}
