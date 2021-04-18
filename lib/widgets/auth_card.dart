import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/auth.dart';
import 'package:shop_app/utils/credentials.dart';

enum AuthMode { Signup, Login }

class _AuthModeHandler {
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

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Size> _heightAnimation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _heightAnimation = Tween<Size>(
            begin: Size(double.infinity, 260), end: Size(double.infinity, 320))
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.fastOutSlowIn));
    _heightAnimation.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedBuilder(
        animation: _heightAnimation,
        builder: (context, child) {
          return Container(
            height: _AuthModeHandler.authMode == AuthMode.Signup ? 320 : 260,
            constraints: BoxConstraints(
              minHeight:
                  _AuthModeHandler.authMode == AuthMode.Signup ? 320 : 260,
            ),
            width: deviceSize.width * 0.75,
            padding: const EdgeInsets.all(16.0),
            child: child,
          );
        },
        child: _AuthCardForm(
          animationController: _animationController,
          heightAnimation: _heightAnimation,
        ),
      ),
    );
  }
}

class _AuthCardForm extends StatefulWidget {
  final AnimationController animationController;
  final Animation<Size> heightAnimation;

  _AuthCardForm(
      {@required this.animationController, @required this.heightAnimation});

  @override
  __AuthCardFormState createState() => __AuthCardFormState();
}

class __AuthCardFormState extends State<_AuthCardForm> {
  var _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey();
  CredentialBuilder _credential = CredentialBuilder();
  final _passwordController = TextEditingController();
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: widget.animationController, curve: Curves.easeIn));
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) return; // Invalid!

    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      switch (_AuthModeHandler.authMode) {
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
    setState(() {
      _AuthModeHandler.switchAuthMode();
    });
    switch (_AuthModeHandler.authMode) {
      case AuthMode.Signup:
        widget.animationController.reverse();
        break;
      case AuthMode.Login:
        widget.animationController.forward();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
            if (_AuthModeHandler.authMode == AuthMode.Signup)
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                constraints: BoxConstraints(
                    minHeight:
                        _AuthModeHandler.authMode == AuthMode.Signup ? 60 : 0,
                    maxHeight:
                        _AuthModeHandler.authMode == AuthMode.Signup ? 120 : 0),
                curve: Curves.easeIn,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: TextFormField(
                    enabled: _AuthModeHandler.authMode == AuthMode.Signup,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _AuthModeHandler.authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text)
                              return 'Passwords do not match!';
                            return null;
                          }
                        : null,
                  ),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                child: Text(_AuthModeHandler.authMode == AuthMode.Login
                    ? 'LOGIN'
                    : 'SIGN UP'),
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 8.0),
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(10)))),
              ),
            TextButton(
              child: Text(
                  '${_AuthModeHandler.authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
              onPressed: _switchAuthMode,
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
