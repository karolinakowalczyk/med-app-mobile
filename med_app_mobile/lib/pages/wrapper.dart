import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_app_mobile/models/user_patient.dart';
import 'package:med_app_mobile/pages/login_page.dart';
import 'package:med_app_mobile/pages/main_page.dart';
import 'package:med_app_mobile/services/auth.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserPatient?>(context);
    final FirebaseAuth _auth = FirebaseAuth.instance;

    // print(user);
    // print(_auth.currentUser!.displayName);

    if (user == null) {
      return const LoginPage();
    } else {
      return const MainPage();
    }
  }
}
