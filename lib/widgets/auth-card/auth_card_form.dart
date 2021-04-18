import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:shop_app/models/auth.dart';
import 'package:shop_app/utils/credentials.dart';
import 'package:shop_app/widgets/auth-card/auth_mode.dart';
import 'package:shop_app/widgets/auth-card/exception_handling.dart';

class AuthCardForm extends StatefulWidget {
  final AnimationController animationController;
  final Function switchAuthMode;

  AuthCardForm({@required this.animationController, this.switchAuthMode});

  @override
  _AuthCardFormState createState() => _AuthCardFormState();
}

class _AuthCardFormState extends State<AuthCardForm> with AuthCardExceptionHandling {
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;
  var _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey();
  CredentialBuilder _credential = CredentialBuilder();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: widget.animationController, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(end: Offset(0, -1.5), begin: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: widget.animationController, curve: Curves.fastOutSlowIn));
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) return; // Invalid!

    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      switch (AuthModeHandler.authMode) {
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
      handleHttpException(e, context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    widget.switchAuthMode();
    switch (AuthModeHandler.authMode) {
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
            if (AuthModeHandler.authMode == AuthMode.Signup)
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                constraints: BoxConstraints(
                    minHeight:
                        AuthModeHandler.authMode == AuthMode.Signup ? 60 : 0,
                    maxHeight:
                        AuthModeHandler.authMode == AuthMode.Signup ? 120 : 0),
                curve: Curves.easeIn,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: TextFormField(
                      enabled: AuthModeHandler.authMode == AuthMode.Signup,
                      decoration:
                          const InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: AuthModeHandler.authMode == AuthMode.Signup
                          ? (value) {
                              if (value != _passwordController.text)
                                return 'Passwords do not match!';
                              return null;
                            }
                          : null,
                    ),
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
                child: Text(AuthModeHandler.authMode == AuthMode.Login
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
                  '${AuthModeHandler.authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
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
