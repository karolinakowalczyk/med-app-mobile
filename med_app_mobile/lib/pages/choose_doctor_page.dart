import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/theme_helper.dart';
import 'package:med_app_mobile/models/appointment_type.dart';
import 'package:med_app_mobile/models/doctor_model.dart';
import 'package:med_app_mobile/providers/appointment_doctor_provider.dart';
import 'package:med_app_mobile/providers/appointment_hour_provider.dart';
import 'package:med_app_mobile/providers/appointment_type_provider.dart';
import 'package:med_app_mobile/providers/doctors_data_provider.dart';
import 'package:provider/provider.dart';

// Ta klasa odpowiada za wyszukanie lekarza
// TODO: trzeba zrobić logikę wyszukiwania i wstawić lekarzy z bazy
class ChooseDoctorPage extends StatefulWidget {
  const ChooseDoctorPage({Key? key}) : super(key: key);

  @override
  State<ChooseDoctorPage> createState() => _ChooseDoctorPageState();
}

class _ChooseDoctorPageState extends State<ChooseDoctorPage> {
  TextEditingController editingController = TextEditingController(text: "");
  String searchingDoctor = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _appointmentHourProv =
        Provider.of<AppointmentHourProvider>(context, listen: false);
    final _appointmentTypeId =
        Provider.of<AppointmentTypeProvider>(context).appointmentTypeId;

    List<Doctor> _doctors =
        Provider.of<DoctorDataProvider>(context, listen: false)
            .getDoctors()
            .where((element) => searchingDoctor != ''
                ? (element.name.toLowerCase())
                    .contains(searchingDoctor.toLowerCase())
                : true)
            .toList();
    _doctors = _doctors
        .where((doctor) => doctor.appointmentTypes
            .where((app) => app.id == _appointmentTypeId)
            .toList()
            .isNotEmpty)
        .toList();

    return Column(
      children: <Widget>[
        Container(
          height: 60,
          alignment: Alignment.topCenter,
          child: TextFormField(
            onChanged: (value) {
              setState(() {
                searchingDoctor = value;
              });
            },
            // controller: editingController,
            decoration: ThemeHelper()
                .textInputDecoration('Search', 'Search', Icons.search),
          ),
        ),
        // TODO: ARTUR - Expanded i automatyczne dopasowanie długości listy byłoby lepsze niż
        // SizedBox, ale wtedy apka ma crash, możesz na to zerknąć jeśli będziesz miał chwilę
        SizedBox(
          height: size.height * 0.59,
          width: double.infinity,
          child: ListView.builder(
            // shrinkWrap: true,
            // itemExtent: 40,
            itemCount: _doctors.length,
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Consumer<AppointmentDoctorProvider>(
                    builder: (_, value, __) {
                  AppointmentType appointmentType = _doctors[index]
                      .appointmentTypes
                      .where((appointmentType) =>
                          appointmentType.id == _appointmentTypeId)
                      .first;
                  return InkWell(
                    splashColor: Colors.blue,
                    onTap: () {
                      value.selctDoctor(index);
                      value.setDoctor(_doctors[index]);
                      value.setAppointmentType(
                        appointmentType,
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.zero,
                      child: ListTile(
                        title: Text(
                          _doctors[index].name,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                          'Price: ' +
                              (_appointmentHourProv.isNFZ == true
                                  ? 'Free, '
                                  : appointmentType.cost.toString() +
                                      ' PLN, ') +
                              'Time: ' +
                              _appointmentHourProv.formateHour(
                                Duration(
                                    minutes: appointmentType.estimatedTime),
                              ),
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        trailing: value.selectedDoctor == index
                            ? const Icon(
                                Icons.check_circle_rounded,
                                color: Colors.blue,
                              )
                            : const Icon(
                                Icons.circle_outlined,
                              ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }
}
