import 'package:flutter/foundation.dart';

class Credential {
  final String email;
  final String password;

  Credential({@required this.email, @required this.password});

  Map<String, dynamic> get toJSON => {
        "email": email,
        "password": password,
      };
}

class CredentialBuilder {
  String email;
  String password;

  CredentialBuilder setEmail(String email) {
    this.email = email;
    return this;
  }

  CredentialBuilder setPassword(String password) {
    this.password = password;
    return this;
  }

  Credential build() {
    return Credential(email: email, password: password);
  }
}
