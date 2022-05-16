import 'package:flutter/material.dart';
import 'package:med_app_mobile/models/user_patient.dart';
import 'package:med_app_mobile/pages/authentication.dart';
import 'package:med_app_mobile/pages/main_wrapper.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserPatient?>(context);
    if (user == null) {
      return const Authentication();
    } else {
      return const MainWrapper();
    }
  }
}
