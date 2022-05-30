import 'dart:math';

import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/accept_dialog.dart';
import 'package:med_app_mobile/models/appointment_model.dart';
import 'package:med_app_mobile/models/appointment_type.dart';
import 'package:med_app_mobile/models/doctor_model.dart';
import 'package:med_app_mobile/models/prescription_model.dart';
import 'package:intl/intl.dart';
import 'package:med_app_mobile/pages/appoint_manager_page.dart';
import 'package:med_app_mobile/providers/appointment_doctor_provider.dart';
import 'package:med_app_mobile/providers/appointment_hour_provider.dart';
import 'package:med_app_mobile/providers/appointment_type_provider.dart';
import 'package:med_app_mobile/providers/doctors_data_provider.dart';
import 'package:med_app_mobile/providers/main_page_provider.dart';
import 'package:med_app_mobile/services/appointment_res_helper.dart';
import 'package:provider/provider.dart';

// W tej klasie znajdują się szablony kafelków dla poszczególnych Tab'ów
class CardHelper {
  //TODO: typy zmiennych w tych widgetach trzeba zmienić na zgodne z ich
  // odpowiednikami w bazie

  TextStyle prescCardTextStyle(
    bool ifExpired,
    FontWeight fontWeight,
    double fontSize,
  ) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: !ifExpired ? Colors.black : Colors.black.withOpacity(0.4),
    );
  }

  TextStyle appointmentCardTextStyle(
    bool ifBefore,
    FontWeight fontWeight,
    double fontSize,
  ) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: ifBefore ? Colors.black : Colors.black.withOpacity(0.4),
    );
  }

  Card appointCard({
    required BuildContext context,
    required String title,
    required String date,
    required String startsTime,
    required String endsTime,
    required String doctor,
    required double? price,
    required bool editing,
    String? appointmentId,
    String? patientId,
  }) {
    final appointment = Appointment(
      id: appointmentId ?? '-',
      title: title,
      doctor: doctor,
      hour: startsTime,
      endHour: endsTime,
      date: date,
      price: price,
    );
    List<String> hourData = startsTime.split(':');
    bool isBefore = false;
    // print(DateFormat('dd-MM-yyyy').format(DateTime.now()));
    if (date != '') {
      isBefore = DateTime.now().compareTo(DateFormat('dd-MM-yyyy')
              .parse(date)
              .add(Duration(
                  hours: int.parse(hourData[0]),
                  minutes: int.parse(hourData[1])))) <
          0;
    }
    return Card(
      elevation: 5,
      color: isBefore ? Colors.white : Colors.grey[400],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title.toUpperCase(),
                  style:
                      appointmentCardTextStyle(isBefore, FontWeight.bold, 20),
                ),
              ],
            ),
            subtitle: Text(
              date,
              style: isBefore
                  ? const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )
                  : TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.4),
                    ),
            ),
            trailing: editing
                ? isBefore
                    ? PopupMenuButton(
                        onSelected: (value) {
                          if (value == 1) {
                            Provider.of<MainPageProvider>(context,
                                    listen: false)
                                .startEditingAppointment(context, appointment)
                                .then((value) {
                              final _doctorDataProvider =
                                  Provider.of<DoctorDataProvider>(context,
                                      listen: false);
                              final Stream<List<Doctor>> _doctors =
                                  _doctorDataProvider.doctors;
                              final Stream<List<AppointmentCategory>>
                                  _appointmentsTypes =
                                  _doctorDataProvider.appointmentCategories;
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return AppointManagerPage(
                                    doctorsStream: _doctors,
                                    appCategoriesStream: _appointmentsTypes,
                                  );
                                }),
                              );
                            });
                          } else if (value == 2) {
                            showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) =>
                                  const AcceptDialog(
                                title: 'Warning',
                                message:
                                    'Are you sure you want to cancel appointment?',
                              ),
                            ).then(
                              (result) async {
                                if (result == true) {
                                  await Provider.of<MainPageProvider>(context,
                                          listen: false)
                                      .removeAppointment(
                                    patientId ?? 'a',
                                    appointmentId!,
                                  );
                                }
                              },
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            child: Text('Edit visit'),
                            value: 1,
                          ),
                          const PopupMenuItem(
                            child: Text('Cancel visit'),
                            value: 2,
                          ),
                        ],
                      )
                    : null
                : InkWell(
                    child: const Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                    onTap: () {
                      AppointmentResHelper.cancelAppReserving(
                        Provider.of<AppointmentDoctorProvider>(context,
                            listen: false),
                        Provider.of<AppointmentHourProvider>(context,
                            listen: false),
                        Provider.of<AppointmentTypeProvider>(context,
                            listen: false),
                        context,
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
            child: Row(
              children: [
                Text(
                  'Starts at: ',
                  style:
                      appointmentCardTextStyle(isBefore, FontWeight.normal, 17),
                ),
                Text(
                  startsTime,
                  style:
                      appointmentCardTextStyle(isBefore, FontWeight.bold, 17),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
            child: Row(
              children: [
                Text(
                  'Ends at: ',
                  style:
                      appointmentCardTextStyle(isBefore, FontWeight.normal, 17),
                ),
                Text(
                  endsTime,
                  style:
                      appointmentCardTextStyle(isBefore, FontWeight.bold, 17),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
            child: Row(
              children: [
                Text(
                  'Doctor: ',
                  style:
                      appointmentCardTextStyle(isBefore, FontWeight.normal, 17),
                ),
                Text(
                  doctor,
                  style:
                      appointmentCardTextStyle(isBefore, FontWeight.bold, 17),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
            child: Row(
              children: [
                Text(
                  'Price: ',
                  style:
                      appointmentCardTextStyle(isBefore, FontWeight.normal, 17),
                ),
                Text(
                  (price != null ? price.toString() : 'NFZ'),
                  style:
                      appointmentCardTextStyle(isBefore, FontWeight.bold, 17),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Card prescCard(
    BuildContext context,
    String patientName,
    String patientId,
    String prescId,
    String doctor,
    String code,
    List<Medicine> medicines,
    DateTime date,
    DateTime expiryDate,
    bool isDone,
  ) {
    bool ifExpired = DateTime.now().compareTo(expiryDate) > 0;
    return Card(
      elevation: 5,
      color: ifExpired || isDone ? Colors.grey[400] : Colors.white,
      shape: RoundedRectangleBorder(
        side: ifExpired
            ? const BorderSide(
                color: Colors.white,
                width: 0,
              )
            : const BorderSide(
                color: Colors.white,
                width: 0,
              ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('dd-MM-yyy').format(date),
                      style: prescCardTextStyle(ifExpired, FontWeight.bold, 19),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Patient: ',
                      style:
                          prescCardTextStyle(ifExpired, FontWeight.normal, 18),
                    ),
                    Text(
                      patientName,
                      style: prescCardTextStyle(ifExpired, FontWeight.bold, 19),
                    ),
                  ],
                ),
              ],
            ),
            subtitle: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'From: ',
                  style: prescCardTextStyle(ifExpired, FontWeight.normal, 18),
                ),
                Text(
                  doctor,
                  style: prescCardTextStyle(ifExpired, FontWeight.bold, 19),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Access code: ',
                      style:
                          prescCardTextStyle(ifExpired, FontWeight.normal, 17),
                    ),
                    Text(
                      code,
                      style: prescCardTextStyle(ifExpired, FontWeight.bold, 19),
                    ),
                  ],
                ),
                // Usuwanie zrealizowanej lub przeterminowanej recepty z bazy danych
                /*
                if (ifExpired || isDone)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      child: const Icon(Icons.delete),
                      onTap: () {
                        showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) => const AcceptDialog(
                            title: 'Warning',
                            message: 'Do you want to remove prescription?',
                          ),
                        ).then(
                          (result) {
                            if (result == true) {
                              Provider.of<MainPageProvider>(
                                context,
                                listen: false,
                              ).removePrescription(
                                patientId,
                                prescId,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  */
                if (isDone)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Fulfilled',
                      style: TextStyle(
                        color: ifExpired
                            ? Colors.green.withOpacity(0.4)
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                if (ifExpired && !isDone)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Expired',
                      style: TextStyle(
                        color: Colors.red.withOpacity(0.4),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                if (!isDone && !ifExpired)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      splashColor: Colors.blue,
                      onTap: () {
                        showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) => const AcceptDialog(
                            title: 'Warning',
                            message:
                                'Are you sure you filled your prescription?',
                          ),
                        ).then(
                          (result) {
                            if (result == true) {
                              Provider.of<MainPageProvider>(
                                context,
                                listen: false,
                              ).checkPrescriptionAsDOne(
                                patientId,
                                prescId,
                              );
                            }
                          },
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          Text(
                            'Mark as done',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
            child: Row(
              children: [
                Text(
                  'Expiry date: ',
                  style: prescCardTextStyle(ifExpired, FontWeight.normal, 17),
                ),
                Text(
                  DateFormat('dd-MM-yyy').format(expiryDate),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: !ifExpired
                        ? Colors.black
                        : isDone
                            ? Colors.black.withOpacity(0.4)
                            : Colors.red[900]!.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: min(medicines.length * 60, 3 * 60),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: ListView.separated(
                      physics: medicines.length > 3
                          ? const ScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: medicines.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 0),
                          title: Text(
                            medicines[i].name,
                            style: prescCardTextStyle(
                              ifExpired,
                              FontWeight.normal,
                              16,
                            ),
                          ),
                          subtitle: Text(medicines[i].description),
                        );
                      },
                      separatorBuilder: (context, i) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: SizedBox(
                          width: 20,
                          height: 1.5,
                          child: Container(
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Card recomCard(
      BuildContext context, String title, String blabla, String description) {
    return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              subtitle: Text(
                blabla,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
              child: Text(
                'Description: $description',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ));
  }
}
