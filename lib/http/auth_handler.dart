import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app/http/check_status.dart';
import 'package:shop_app/utils/credentials.dart';

class AuthHandler with StatusChecker {
  final url = Uri.https("identitytoolkit.googleapis.com",
      "/v1/accounts:signInWithCustomToken?key=${String.fromEnvironment('FIREBASE_API_KEY')}");

  final Credential credential;

  AuthHandler(this.credential);

  Future<http.Response> signup() async {
    return await http.post(url, body: json.encode(credential.toJSON));
  }
}
