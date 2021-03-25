import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthUrlHandler {
  static final baseUrl =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=${String.fromEnvironment('FIREPABE_API_KEY')}";

  AuthUrlHandler({@required collectionName});
}
