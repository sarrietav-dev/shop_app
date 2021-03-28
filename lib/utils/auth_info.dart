
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

  @override
  String toString() {
    return "idToken: $idToken, expiresIn: $expiresIn, localId: $localId";
  }
}
