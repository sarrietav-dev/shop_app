import 'package:flutter/foundation.dart';

class Credential {
  final String username;
  final String password;

  Credential({@required this.username, @required this.password});

  Map<String, dynamic> get toJSON => {
        "username": username,
        "password": password,
      };
}

class CredentialBuilder {
  String username;
  String password;

  CredentialBuilder setUsername(String username) {
    this.username = username;
    return this;
  }

  CredentialBuilder setPassword(String password) {
    this.password = password;
    return this;
  }

  Credential build() {
    return Credential(username: username, password: password);
  }
}
