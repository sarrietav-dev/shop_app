import 'package:flutter/foundation.dart';
import 'package:shop_app/http/auth_handler.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;

  Future<void> signup(String email, String password) async {
    return await AuthHandler(username: email, password: password).signup();
  }
}
