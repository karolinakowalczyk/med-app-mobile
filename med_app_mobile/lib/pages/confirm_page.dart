import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/card_helper.dart';
import 'package:med_app_mobile/providers/appointment_doctor_provider.dart';
import 'package:med_app_mobile/providers/appointment_hour_provider.dart';
import 'package:provider/provider.dart';

// Prosta klasa pokazująca szczegóły zaplanowanej wizyty.
// TODO: musi zwracać prawdziwe wartości z "Doctor" i "Date"
class ConfirmPage extends StatefulWidget {
  final double remainHeigth;
  const ConfirmPage({
    required this.remainHeigth,
    Key? key,
  }) : super(key: key);

  @override
  State<ConfirmPage> createState() => _ConfirmPageState();
}

// TODO: tutaj mają być prawdziwe szczegóły wizyty
class _ConfirmPageState extends State<ConfirmPage> {
  @override
  Widget build(BuildContext context) {
    const remainingSpace = 200;
    final contentSpace = widget.remainHeigth - remainingSpace;
    return Consumer<AppointmentDoctorProvider>(
      builder: (_, appDoctor, __) => Consumer<AppointmentHourProvider>(
        builder: (_, appHour, __) => SizedBox(
          height: contentSpace,
          child: Column(
            children: [
              Container(
                child: CardHelper().appointCard(
                  context: context,
                  title: appDoctor.appointmentType != null
                      ? appDoctor.appointmentType!.name
                      : 'Appointment',
                  date: appHour.date,
                  startsTime: appHour.formateHour(appHour.selectedHour),
                  endsTime: appHour.formateHour(appHour.endHour),
                  doctor: appDoctor.doctor != null
                      ? appDoctor.doctor!.name
                      : 'Random',
                  price: appDoctor.appointmentType != null
                      ? appHour.isNFZ == true
                          ? null
                          : appDoctor.appointmentType!.cost
                      : 0,
                  editing: false,
                ),
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
