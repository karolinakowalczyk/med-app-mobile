import 'package:flutter/material.dart';
import 'package:med_app_mobile/pages/login_page.dart';
import 'package:med_app_mobile/pages/registration_page.dart';

enum AuthModes {
  login,
  registration,
}

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  AuthModes _authMode = AuthModes.login;

  void _changeAuthMode(AuthModes newMode) {
    setState(() {
      _authMode = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _authMode == AuthModes.login
        ? LoginPage(_changeAuthMode)
        : RegistrationPage(_changeAuthMode);
  }
}
