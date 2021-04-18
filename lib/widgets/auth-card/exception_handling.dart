import 'dart:io';

import 'package:flutter/material.dart';

mixin AuthCardExceptionHandling {
  void handleHttpException(HttpException e, BuildContext context) => showDialog(
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
}