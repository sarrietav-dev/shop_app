import 'package:flutter/foundation.dart';

class AuthInfo {
  final String idToken;
  final String expiresIn;
  final String localId;

  AuthInfo(
      {@required this.idToken,
      @required this.expiresIn,
      @required this.localId});

  @override
  String toString() {
    return "idToken: $idToken, expiresIn: $expiresIn, localId: $localId";
  }
}
