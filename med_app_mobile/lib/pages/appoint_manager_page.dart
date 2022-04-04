import 'package:flutter/material.dart';

// TODO: ta klasa będzie odpowiadać za umawianie i edytowanie wizyt
class AppointManagerPage extends StatefulWidget {
  const AppointManagerPage({Key? key}) : super(key: key);

  @override
  State<AppointManagerPage> createState() => _AppointManagerPageState();
}

class _AppointManagerPageState extends State<AppointManagerPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AppointManagerPage"),
      ),
      body: const Center(
        child: Text("AppointManagerPage"),
      ),
    );
  }

}