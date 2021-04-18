import 'package:flutter/material.dart';
import 'package:shop_app/widgets/auth-card/auth_card_form.dart';
import 'package:shop_app/widgets/auth-card/auth_mode.dart';

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

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void switchAuthMode() {
    setState(() {
      AuthModeHandler.switchAuthMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: AuthModeHandler.authMode == AuthMode.Signup ? 320 : 260,
        constraints: BoxConstraints(
          minHeight: AuthModeHandler.authMode == AuthMode.Signup ? 320 : 260,
        ),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: AuthCardForm(
          animationController: _animationController,
          switchAuthMode: switchAuthMode,
        ),
      ),
    );
  }
}
