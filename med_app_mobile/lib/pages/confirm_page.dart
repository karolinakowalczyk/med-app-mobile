import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/card_helper.dart';
import 'package:med_app_mobile/providers/appointment_doctor_provider.dart';
import 'package:med_app_mobile/providers/appointment_hour_provider.dart';
import 'package:med_app_mobile/providers/doctors_data_provider.dart';
import 'package:provider/provider.dart';

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
    final size = MediaQuery.of(context).size;
    final doctorsData = Provider.of<DoctorDataProvider>(context, listen: false);

    return Consumer<AppointmentDoctorProvider>(
      builder: (_, appDoctor, __) => Consumer<AppointmentHourProvider>(
        builder: (_, appHour, __) => SizedBox(
          height: size.height * 0.65,
          child: Column(
            children: [
              SizedBox(
                height: 160,
                child: Container(
                  child: CardHelper().appointCard(
                      context,
                      'appointment data',
                      appHour.date,
                      appHour.selectedHour,
                      "Doctor: ${appDoctor.doctor != null ? appDoctor.doctor!.name : 'Random'}"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
