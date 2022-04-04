// ignore_for_file: deprecated_member_use

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:med_app_mobile/models/user_patient.dart';
import 'package:med_app_mobile/pages/wrapper.dart';
import 'package:med_app_mobile/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Color _accentColor = HexColor('#26C6DA');

  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserPatient?>.value(
      value: AuthServices().user,
      // value: _auth.authStateChanges(),
      builder: (context, _) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of application.
            primaryColor: Colors.indigo,
            accentColor: _accentColor,
            scaffoldBackgroundColor: Colors.grey.shade100,
            primarySwatch: Colors.indigo,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.indigo,
            ),
          ),
          home: const Wrapper(),
          debugShowCheckedModeBanner: false,
        );
      },
      initialData: null,
    );
  }
}
