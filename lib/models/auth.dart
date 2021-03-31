import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop_app/http/auth_handler.dart';
import 'package:shop_app/utils/auth_info.dart';
import 'package:shop_app/utils/credentials.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    await _saveToken();
  }

  set _setAuthInfo(AuthInfo authInfo) {
    Auth.authInfo = authInfo;
  }

  void _autoLogout() {
    if (_logoutTimer != null) _logoutTimer.cancel();
    _logoutTimer = Timer(Duration(seconds: authInfo.timeToExpiry), logout);
  }

  void logout() {
    authInfo = AuthInfo();
    _clearSharedPreferences();
    notifyListeners();
  }

  void _clearSharedPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove("userData");
  }

  Future _saveToken() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString("userData", json.encode(authInfo.toJson));
  }

  Future<bool> tryAutoLogin() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey("userData")) return false;

    final userData = json.decode(preferences.getString("userData"));
    final extractedAuthInfo = AuthInfoBuilder.json(userData).build();

    if (!extractedAuthInfo.isExpiryDateValid) return false;

    Auth.authInfo = extractedAuthInfo;

    notifyListeners();
    return true;
  }
}
