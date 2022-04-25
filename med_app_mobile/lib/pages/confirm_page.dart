import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/card_helper.dart';

// Prosta klasa pokazująca szczegóły zaplanowanej wizyty.
// TODO: musi zwracać prawdziwe wartości z "Doctor" i "Date"
class ConfirmPage extends StatefulWidget {
  const ConfirmPage({Key? key}) : super(key: key);

  @override
  State<ConfirmPage> createState() => _ConfirmPageState();
}

// TODO: tutaj mają być prawdziwe szczegóły wizyty
class _ConfirmPageState extends State<ConfirmPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: Container(
        child: CardHelper().appointCard(
          context, 
          'lorem ipsum',
          'Tuesday, June 28, 2022', 
          '13:15 AM', 
          'dr Saul Tarvitz'
        ),
      ),
    );
  }
}
