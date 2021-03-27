import 'package:flutter/foundation.dart';
import 'package:shop_app/http/auth_handler.dart';
import 'package:shop_app/http/url_handlers/api_url_handler.dart';
import 'package:shop_app/utils/auth_info.dart';
import 'package:shop_app/utils/credentials.dart';

class Auth with ChangeNotifier {
  AuthInfo authInfo = AuthInfo();

  Future<void> signup(Credential credential) async {
    _setAuthInfo = await AuthHandler(credential).signup();
    notifyListeners();
  }

  Future<void> login(Credential credential) async {
    _setAuthInfo = await AuthHandler(credential).login();
    notifyListeners();
  }

  set _setAuthInfo(AuthInfo authInfo) {
    this.authInfo = authInfo;
    ApiUrlHandler.token = this.authInfo.idToken;
  }
}
