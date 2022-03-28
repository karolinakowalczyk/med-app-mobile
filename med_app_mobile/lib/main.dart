// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Color _primaryColor = HexColor('#4B62FF');
  final Color _accentColor = HexColor('#26C6DA');

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of application.
        
        primaryColor: _primaryColor,
        accentColor: _accentColor,
        scaffoldBackgroundColor: Colors.grey.shade100,
        primarySwatch: Colors.indigo,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
        ),
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

