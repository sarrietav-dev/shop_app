enum AuthMode { Signup, Login }

class AuthModeHandler {
  static AuthMode authMode = AuthMode.Login;

  static void switchAuthMode() {
    switch (authMode) {
      case AuthMode.Signup:
        authMode = AuthMode.Login;
        break;
      case AuthMode.Login:
        authMode = AuthMode.Signup;
        break;
    }
  }
}
