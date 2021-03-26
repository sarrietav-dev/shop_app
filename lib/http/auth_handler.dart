import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/http/check_status.dart';
import 'package:shop_app/utils/credentials.dart';

class AuthHandler with StatusChecker {
  final url = Uri.https("identitytoolkit.googleapis.com", "/v1/accounts:signUp",
      {"key": env["FIREBASE_API_KEY"]});

  final Credential credential;

  AuthHandler(this.credential);

  Future<http.Response> signup() async {
    print(url.toString());
    return await http.post(url,
        body: json.encode(
            credential.toJSON..putIfAbsent("returnSecureToken", () => true)));
  }
}
