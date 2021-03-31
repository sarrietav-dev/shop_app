import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shop_app/http/auth_handler.dart';
import 'package:shop_app/utils/auth_info.dart';
import 'package:shop_app/utils/credentials.dart';

class Auth with ChangeNotifier {
  static AuthInfo authInfo = AuthInfo();
  Timer _logoutTimer;

  Future<void> signup(Credential credential) async {
    _setAuthInfo = await AuthHandler(credential).signup();
    notifyListeners();
  }

  Future<void> login(Credential credential) async {
    _setAuthInfo = await AuthHandler(credential).login();
    _autoLogout();
    notifyListeners();
  }

  set _setAuthInfo(AuthInfo authInfo) {
    Auth.authInfo = authInfo;
  }

  void logout() {
    authInfo = AuthInfo();
    notifyListeners();
  }

  void _autoLogout() {
    if (_logoutTimer != null) _logoutTimer.cancel();
    var timeToExpiry = authInfo.expiresIn.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
