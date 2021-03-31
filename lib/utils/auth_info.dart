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

  get timeToExpiry => expiresIn.difference(DateTime.now()).inSeconds;

  get isExpiryDateValid => expiresIn.isAfter(DateTime.now());

  @override
  String toString() {
    return "idToken: $idToken, expiresIn: $expiresIn, localId: $localId";
  }
}

class AuthInfoBuilder {
  String idToken;
  DateTime expiresIn;
  String localId;

  AuthInfoBuilder.json(Map<String, dynamic> data) {
    idToken = data["idToken"];
    expiresIn = DateTime.parse(data["expiresIn"]);
    localId = data["localId"];
  }

  AuthInfo build() {
    return AuthInfo(idToken: idToken, expiresIn: expiresIn, localId: localId);
  }
}
