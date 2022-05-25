import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/theme_helper.dart';
import 'package:med_app_mobile/providers/appointment_hour_provider.dart';
import 'package:med_app_mobile/providers/appointment_type_provider.dart';
import 'package:med_app_mobile/providers/doctors_data_provider.dart';
import 'package:provider/provider.dart';

class ChooseAppTypePage extends StatefulWidget {
  const ChooseAppTypePage({Key? key}) : super(key: key);

  @override
  State<ChooseAppTypePage> createState() => _ChooseAppTypePageState();
}

class _ChooseAppTypePageState extends State<ChooseAppTypePage> {
  String searchingType = "";
  bool nfz = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final _appTypes = Provider.of<DoctorDataProvider>(context, listen: false)
    //     .getAppointmentTypes()
    //     .where((element) => searchingType != ''
    //         ? (element.name.toLowerCase()).contains(searchingType.toLowerCase())
    //         : true)
    //     .toList();

    final _appCategories = Provider.of<DoctorDataProvider>(context,
            listen: false)
        .getAppointmentCategories()
        .where((element) => searchingType != ''
            ? (element.name.toLowerCase()).contains(searchingType.toLowerCase())
            : true)
        .toList();
    final appointmentHourProv =
        Provider.of<AppointmentHourProvider>(context, listen: false);

    return Column(
      children: <Widget>[
        Container(
            height: 60,
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('NFZ patient',
                    style: TextStyle(
                      fontSize: 22,
                    )),
                Switch(
                  value: nfz,
                  onChanged: (value) {
                    appointmentHourProv.setIsNFZ(value);
                    setState(() {
                      nfz = value;
                    });
                  },
                  activeColor: Colors.blue,
                ),
              ],
            )),
        Container(
          height: 60,
          alignment: Alignment.topCenter,
          child: TextFormField(
            onChanged: (value) {
              setState(() {
                searchingType = value;
              });
            },
            // controller: editingController,
            decoration: ThemeHelper()
                .textInputDecoration('Search', 'Search', Icons.search),
          ),
        ),
        SizedBox(
          height: size.height * 0.515,
          width: double.infinity,
          child: ListView.builder(
              // shrinkWrap: true,,
              // itemExtent: 50,
              itemCount: _appCategories.length,
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Consumer<AppointmentTypeProvider>(
                    builder: (_, value, __) => InkWell(
                      splashColor: Colors.blue,
                      onTap: () {
                        value.selectAppType(index);
                        value
                            .setAppointmentCategoryId(_appCategories[index].id);
                      },
                      child: Container(
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          title: Text(
                            _appCategories[index].name,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          /*
                          subtitle: Text(
                            'Price: ' +
                                (nfz == true
                                    ? 'Free, '
                                    : _appTypes[index].cost.toString() +
                                        ' PLN, ') +
                                'Time: ' +
                                appointmentHourProv.formateHour(
                                  Duration(
                                      minutes: _appTypes[index].estimatedTime),
                                ),
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          */
                          trailing: value.selectedType == index
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.blue,
                                )
                              : const Icon(
                                  Icons.circle_outlined,
                                ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
