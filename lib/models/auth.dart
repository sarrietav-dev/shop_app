import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop_app/http/auth_handler.dart';
import 'package:shop_app/utils/credentials.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;

  Future<void> signup(Credential credential) async {
    final response = await AuthHandler(credential).signup();
    print(response.body);
    return response;
  }
}
