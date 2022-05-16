import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/theme_helper.dart';
import 'package:med_app_mobile/models/doctor_model.dart';
import 'package:med_app_mobile/providers/appointment_doctor_provider.dart';
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
  var items = <String>[];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _doctors = Provider.of<DoctorDataProvider>(context, listen: false)
        .getDoctors()
        .where((element) => searchingDoctor != ''
            ? (element.name.toLowerCase())
                .contains(searchingDoctor.toLowerCase())
            : true)
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
            itemExtent: 40,
            itemCount: _doctors.length,
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int index) {
              return Consumer<AppointmentDoctorProvider>(
                builder: (_, value, __) => InkWell(
                  splashColor: Colors.blue,
                  onTap: () {
                    value.selctDoctor(index);
                    value.setDoctor(_doctors[index]);
                  },
                  child: ListTile(
                    title: Text(
                      _doctors[index].name,
                      style: const TextStyle(
                        fontSize: 25,
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
            },
          ),
        ),
      ],
    );
  }
}
