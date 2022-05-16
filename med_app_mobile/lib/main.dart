// ignore_for_file: deprecated_member_use

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:med_app_mobile/models/user_patient.dart';
import 'package:med_app_mobile/pages/auth_wrapper.dart';
import 'package:med_app_mobile/providers/appointment_doctor_provider.dart';
import 'package:med_app_mobile/providers/appointment_hour_provider.dart';
import 'package:med_app_mobile/providers/doctors_data_provider.dart';
import 'package:med_app_mobile/providers/main_page_provider.dart';
import 'package:med_app_mobile/providers/user_provider.dart';
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

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    final authServices = AuthServices();
    return StreamProvider<UserPatient?>.value(
      value: authServices.user,
      builder: (context, _) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<AppointmentHourProvider>(
              create: (context) => AppointmentHourProvider(),
            ),
            ChangeNotifierProvider<AppointmentDoctorProvider>(
              create: (context) => AppointmentDoctorProvider(),
            ),
            ChangeNotifierProvider<DoctorDataProvider>(
              create: (context) => DoctorDataProvider(),
            ),
            ChangeNotifierProvider<MainPageProvider>(
              create: (context) => MainPageProvider(),
            ),
            Provider<UserProvider>(
              create: (context) => UserProvider(user: authServices.getUser()),
            ),
          ],
          child: MaterialApp(
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
            home: const AuthWrapper(),
            debugShowCheckedModeBanner: false,
          ),
        );
      },
      initialData: null,
    );
  }
}
