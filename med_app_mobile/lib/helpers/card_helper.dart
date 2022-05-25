import 'dart:math';

import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/accept_dialog.dart';
import 'package:med_app_mobile/models/prescription_model.dart';
import 'package:intl/intl.dart';
import 'package:med_app_mobile/providers/appointment_doctor_provider.dart';
import 'package:med_app_mobile/providers/appointment_hour_provider.dart';
import 'package:med_app_mobile/providers/appointment_type_provider.dart';
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

  TextStyle activeTextStyle(
    bool ifExpired,
    FontWeight fontWeight,
    double fontSize,
  ) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: ifExpired ? Colors.black : Colors.black.withOpacity(0.4),
    );
  }

  Card appointCard(
    BuildContext context,
    String title,
    String date,
    String time,
    String doctor,
    bool editing, {
    String? appointmentId,
  }) {
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
                  date,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                trailing: editing
                    ? PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const Text('Edit visit'),
                            value: 1,
                            onTap: () {},
                          ),
                          const PopupMenuItem(
                            child: Text('Cancel visit'),
                            value: 2,
                          ),
                        ],
                      )
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
                      )),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
              child: Text(
                'Starts at: $time',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
              child: Text(
                doctor,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ));
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
            title: Row(
              children: [
                Text(
                  'Patient: ',
                  style: prescCardTextStyle(ifExpired, FontWeight.normal, 18),
                ),
                Text(
                  patientName,
                  style: prescCardTextStyle(ifExpired, FontWeight.bold, 19),
                ),
              ],
            ),
            subtitle: Row(
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
            trailing: Text(
              DateFormat('dd-MM-yyy').format(date),
              style: prescCardTextStyle(ifExpired, FontWeight.bold, 19),
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Fulfilled',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                if (!isDone && !ifExpired)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      child: const Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      onTap: () {
                        showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) => const AcceptDialog(
                            title: 'Warning',
                            message: 'Are you sure you fill your prescription?',
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
