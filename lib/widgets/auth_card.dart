import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/auth.dart';
import 'package:shop_app/utils/credentials.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  CredentialBuilder _credential = CredentialBuilder();
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _submit() async {
    if (!_formKey.currentState.validate()) return; // Invalid!

    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      switch (_authMode) {
        case AuthMode.Signup:
          await Provider.of<Auth>(context, listen: false)
              .signup(_credential.build());
          break;
        case AuthMode.Login:
          await Provider.of<Auth>(context, listen: false)
              .login(_credential.build());
          break;
      }
    } on HttpException catch (e) {
      handleHttpException(e);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void handleHttpException(HttpException e) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("An error ocurred"),
            content: Text(getErrorContentText(e)),
            actions: [
              TextButton(
                  onPressed: Navigator.of(context).pop, child: Text("Ok")),
            ],
          ));

  String getErrorContentText(HttpException e) {
    switch (e.message) {
      case "EMAIL_EXISTS":
        return "The email address is already in use by another account.";
        break;
      case "OPERATION_NOT_ALLOWED":
        return "Password sign-in is disabled for this project.";
        break;
      case "TOO_MANY_ATTEMPTS_TRY_LATER":
        return "We have blocked all requests from this device due to unusual activity. Try again later.";
        break;
      case "EMAIL_NOT_FOUND":
        return "There is no user record corresponding to this identifier. The user may have been deleted.";
        break;
      case "INVALID_PASSWORD":
        return " The password is invalid or the user does not have a password.";
        break;
      case "USER_DISABLED":
        return "The user account has been disabled by an administrator.";
        break;
      case "WEAK_PASSWORD":
        return "The password must be 6 characters long or more";
        break;
      default:
        return "Authentication has failed";
        break;
    }
  }

  void _switchAuthMode() {
    switch (_authMode) {
      case AuthMode.Signup:
        setState(() {
          _authMode = AuthMode.Login;
        });
        break;
      case AuthMode.Login:
        setState(() {
          _authMode = AuthMode.Signup;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: _credential.setEmail,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5)
                      return 'Password is too short!';
                    return null;
                  },
                  onSaved: _credential.setPassword,
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text)
                              return 'Passwords do not match!';
                            return null;
                          }
                        : null,
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        shape: const RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(10)))),
                  ),
                TextButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
