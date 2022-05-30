import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/theme_helper.dart';
import 'package:med_app_mobile/models/doctor_model.dart';
import 'package:med_app_mobile/providers/appointment_doctor_provider.dart';
import 'package:med_app_mobile/providers/appointment_hour_provider.dart';
import 'package:med_app_mobile/providers/appointment_type_provider.dart';
import 'package:med_app_mobile/providers/doctors_data_provider.dart';
import 'package:provider/provider.dart';

class ChooseAppTypePage extends StatefulWidget {
  final double remainHeigth;
  const ChooseAppTypePage({
    required this.remainHeigth,
    Key? key,
  }) : super(key: key);

  @override
  State<ChooseAppTypePage> createState() => _ChooseAppTypePageState();
}

class _ChooseAppTypePageState extends State<ChooseAppTypePage> {
  String searchingType = "";
  bool nfz = false;

  @override
  Widget build(BuildContext context) {
    final docotrsDataProv =
        Provider.of<DoctorDataProvider>(context, listen: false);
    final _appCategories = docotrsDataProv
        .getAppointmentCategories()
        .where((element) => searchingType != ''
            ? (element.name.toLowerCase()).contains(searchingType.toLowerCase())
            : true)
        .toList();
    final appointmentHourProv =
        Provider.of<AppointmentHourProvider>(context, listen: false);

    final typeProv =
        Provider.of<AppointmentTypeProvider>(context, listen: false);

    final appointmentDoctorProv =
        Provider.of<AppointmentDoctorProvider>(context, listen: false);

    nfz = appointmentHourProv.isNFZ;

    const remainingSpace = 200;
    final contentSpace = widget.remainHeigth - remainingSpace;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: contentSpace,
        maxHeight: contentSpace,
      ),
      child: Column(
        children: <Widget>[
          Container(
              height: 60,
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'NFZ patient',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  Switch(
                    value: nfz,
                    onChanged: (value) {
                      // ignore: unnecessary_null_comparison
                      if (typeProv.prevAppointment != null) {
                        if (appointmentHourProv.isNFZ !=
                            (typeProv.prevAppointment!.price != null)) {
                          appointmentHourProv.selctHour(
                              const Duration(minutes: 0),
                              const Duration(minutes: 0));
                        } else {
                          appointmentHourProv.setOldDateForEditing(
                              typeProv.prevAppointment!.date);
                          final String doctComp;
                          if (appointmentDoctorProv.doctor != null) {
                            doctComp = appointmentDoctorProv.doctor!.name;
                          } else {
                            doctComp = '';
                          }
                          if (typeProv.prevAppointment!.doctor != doctComp) {
                            final Doctor doctor = docotrsDataProv
                                .getDoctors()
                                .firstWhere((element) =>
                                    element.name ==
                                    typeProv.prevAppointment!.doctor);

                            final int doctorIndex = docotrsDataProv
                                .getDoctors()
                                .where((doctor) => doctor.appointmentTypes
                                    .where((app) =>
                                        app.id == typeProv.appointmentTypeId)
                                    .toList()
                                    .isNotEmpty)
                                .toList()
                                .indexOf(doctor);
                            appointmentDoctorProv.setDoctor(doctor);
                            appointmentDoctorProv.selctDoctor(doctorIndex);
                          }
                          if (appointmentHourProv.selectedHour.compareTo(
                                  appointmentHourProv.stringToDuration(
                                      typeProv.prevAppointment!.hour)) !=
                              0) {
                            appointmentHourProv.selctHour(
                              appointmentHourProv.stringToDuration(
                                  typeProv.prevAppointment!.hour),
                              appointmentHourProv.stringToDuration(
                                  typeProv.prevAppointment!.endHour),
                            );
                          }
                        }
                      }
                      appointmentHourProv.setIsNFZ(value);
                      setState(() {
                        nfz = value;
                      });
                      appointmentHourProv.setRefresh(true);
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
            height: contentSpace - 130,
            child: ListView.builder(
                shrinkWrap: true,
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
                          appointmentHourProv.selctHour(
                              const Duration(minutes: 0),
                              const Duration(minutes: 0));
                          appointmentHourProv.setDate('');
                          final doctorProv =
                              Provider.of<AppointmentDoctorProvider>(context,
                                  listen: false);

                          if (value.prevAppointment != null) {
                            if (value.prevAppointment!.title ==
                                    _appCategories[index].name &&
                                value.selectedType != index &&
                                // value.prevAppointment!.title !=
                                //     value.appointmentTypeId &&
                                appointmentHourProv.isNFZ !=
                                    (typeProv.prevAppointment!.price != null)) {
                              appointmentHourProv.setOldDateForEditing(
                                  value.prevAppointment!.date);
                              appointmentHourProv.selctHour(
                                appointmentHourProv.stringToDuration(
                                    value.prevAppointment!.hour),
                                appointmentHourProv.stringToDuration(
                                    value.prevAppointment!.endHour),
                              );
                              final Doctor doctor = docotrsDataProv
                                  .getDoctors()
                                  .firstWhere((element) =>
                                      element.name ==
                                      value.prevAppointment!.doctor);

                              final int doctorIndex = docotrsDataProv
                                  .getDoctors()
                                  .where((doctor) => doctor.appointmentTypes
                                      .where((app) =>
                                          app.id == value.appointmentTypeId)
                                      .toList()
                                      .isNotEmpty)
                                  .toList()
                                  .indexOf(doctor);
                              doctorProv.setDoctor(doctor);
                              doctorProv.selctDoctor(doctorIndex);
                            } else {
                              appointmentHourProv.setOldDateForEditing(null);
                              appointmentHourProv.selctHour(
                                  const Duration(minutes: 0),
                                  const Duration(minutes: 0));
                              doctorProv.setDoctor(null);
                              doctorProv.selctDoctor(-1);
                            }
                          } else {
                            if (index != value.selectedType) {
                              doctorProv.selctDoctor(-1);
                            }
                          }

                          value.setAppointmentCategoryId(
                              _appCategories[index].id);
                          appointmentHourProv.setRefresh(true);
                          value.selectAppType(index);
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
      ),
    );
  }
}
