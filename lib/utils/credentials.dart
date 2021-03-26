import 'package:flutter/foundation.dart';

class Credential {
  final String username;
  final String password;

  Credential({@required this.username, @required this.password});

  get toJSON => {
        "username": username,
        "password": password,
      };
}
