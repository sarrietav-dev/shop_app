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
