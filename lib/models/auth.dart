import 'package:flutter/foundation.dart';
import 'package:shop_app/http/auth_handler.dart';
import 'package:shop_app/utils/auth_info.dart';
import 'package:shop_app/utils/credentials.dart';

class Auth with ChangeNotifier {
  AuthInfo authInfo;

  Future<void> signup(Credential credential) async {
    authInfo = await AuthHandler(credential).signup();
  }

  Future<void> login(Credential credential) async {
    authInfo = await AuthHandler(credential).login();
  }
}
