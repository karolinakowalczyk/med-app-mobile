import 'package:flutter/material.dart';
import 'package:med_app_mobile/models/user_patient.dart';
import 'package:med_app_mobile/services/auth.dart';
import 'package:provider/provider.dart';

// Główna strona - do zrobienia na później
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final AuthServices _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserPatient?>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Main Page',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _auth.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(user!.email),
            Text(user.name),
          ],
        ),
      ),
    );
  }
}
