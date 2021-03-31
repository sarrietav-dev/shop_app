class AuthInfo {
  final String idToken;
  final DateTime expiresIn;
  final String localId;

  AuthInfo({this.idToken, this.expiresIn, this.localId});

  bool get isAuth {
    if (idToken != null &&
        expiresIn.isAfter(DateTime.now()) &&
        expiresIn != null) return true;
    return false;
  }

  get toJson => {
        "idToken": idToken,
        "expiresIn": expiresIn.toIso8601String(),
        "localId": localId,
      };

  @override
  String toString() {
    return "idToken: $idToken, expiresIn: $expiresIn, localId: $localId";
  }
}
