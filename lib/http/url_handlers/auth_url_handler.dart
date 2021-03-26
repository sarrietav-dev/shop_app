import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app/http/check_status.dart';

class AuthUrlHandler with StatusChecker {
  final url = Uri.https("identitytoolkit.googleapis.com",
      "/v1/accounts:signInWithCustomToken?key=${String.fromEnvironment('FIREPABE_API_KEY')}");

  final String username;
  final String password;

  AuthUrlHandler({this.username, this.password});

  Future<http.Response> signup() async {
    return await http.post(url, body: json.encode(jsonValues));
  }

  get jsonValues => {"username": username, "password": password};
}
