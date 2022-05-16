import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_app_mobile/models/doctor_model.dart';
import 'package:med_app_mobile/providers/appointment_doctor_provider.dart';
import 'package:med_app_mobile/providers/appointment_hour_provider.dart';
import 'package:provider/provider.dart';

class ChooseDatePage extends StatefulWidget {
  const ChooseDatePage({Key? key}) : super(key: key);

  @override
  State<ChooseDatePage> createState() => _ChooseDatePageState();
}

class _ChooseDatePageState extends State<ChooseDatePage> {
  DateTime currentDate = DateTime.now();
  late String formattedDate = DateFormat('dd-MM-yyy').format(currentDate);

  Future<String> _selectDate(BuildContext context) async {
    String date = "";
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2021),
      lastDate: DateTime.now().add(
        const Duration(days: 183),
      ),
    );
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        formattedDate = DateFormat('dd-MM-yyy').format(pickedDate);
      });
    }
    return formattedDate;
  }

  @override
  void initState() {
    super.initState();
    Provider.of<AppointmentHourProvider>(context, listen: false).setDate(
      formattedDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appointmentHourProv =
        Provider.of<AppointmentHourProvider>(context, listen: false);

    return Consumer<AppointmentDoctorProvider>(
      builder: (_, value, __) {
        final selectedDoctor = value.doctor ??
            Doctor(
              id: 'Random',
              name: 'Random',
              email: '',
              phone: '',
            );
        return StreamBuilder<List<String>>(
            stream: appointmentHourProv.availableAppointments(
              formattedDate,
              value.doctor == null ? 'Random' : value.doctor!.id,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: size.height * 0.65,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return SizedBox(
                height: size.height * 0.65,
                child: Column(
                  children: <Widget>[
                    Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text(selectedDoctor.name),
                              trailing: const Icon(Icons.person),
                            )
                          ],
                        )),
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              formattedDate,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          OutlinedButton(
                              onPressed: () async {
                                final date = await _selectDate(context);
                                appointmentHourProv.setDate(
                                  date,
                                );
                              },
                              child: const Icon(Icons.calendar_month),
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide.none,
                                  padding: const EdgeInsets.only(left: 5))),
                        ],
                      ),
                    ),
                    /* TODO: tutaj mają być dostępne dni i godziny przyjęć
                    Ok, tutaj trzeba dodać okna w których będą godziny, dać jakiś
                    fajny Padding albo Margin, jeśli bardzo ściśniesz okna godzin i samych
                    godzin będzie w bazie mało to nawet nie będziesz musiał nic przewijać.
                    Jeszcze jakiś komunikat w stylu "Wszystkie godziny zajęte" jak nie ma 
                    już miejsc.
                    */
                    Consumer<AppointmentHourProvider>(
                      builder: (context, value, child) {
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const ListTile(
                                title: Text('Choose an hour'),
                                trailing: Icon(Icons.schedule),
                              ),
                              Container(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: SizedBox(
                                  height: 196,
                                  child: GridView.count(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    children: [
                                      ...appointmentHourProv
                                          .getAppointments()
                                          .map((element) =>
                                              Consumer<AppointmentHourProvider>(
                                                builder: (_, value, __) =>
                                                    InkWell(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(36),
                                                  ),
                                                  onTap: () {
                                                    var endInd =
                                                        appointmentHourProv
                                                            .getAppointments()
                                                            .indexOf(element);
                                                    value.selctHour(
                                                      element,
                                                      endInd < 15
                                                          ? appointmentHourProv
                                                                  .getAppointments()[
                                                              endInd + 1]
                                                          : "16:00",
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      boxShadow:
                                                          value.selectedHour ==
                                                                  element
                                                              ? const [
                                                                  BoxShadow(
                                                                    blurRadius:
                                                                        8,
                                                                    spreadRadius:
                                                                        3,
                                                                    color: Colors
                                                                        .blue,
                                                                  )
                                                                ]
                                                              : [],
                                                      color:
                                                          value.selectedHour ==
                                                                  element
                                                              ? Colors.blue
                                                              : Colors.white,
                                                      border: Border.all(
                                                        color: Colors.blue,
                                                        width: 1.5,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(
                                                            36), //36
                                                      ),
                                                    ),
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Text(
                                                            element,
                                                            style: TextStyle(
                                                              fontSize: 17,
                                                              color:
                                                                  value.selectedHour ==
                                                                          element
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .blue,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              );
            });
      },
    );
  }
}
