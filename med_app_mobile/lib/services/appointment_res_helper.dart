import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/alert_window_helper.dart';
import 'package:med_app_mobile/models/appointment_model.dart';
import 'package:med_app_mobile/models/user_patient.dart';
import 'package:med_app_mobile/pages/main_page.dart';
import 'package:med_app_mobile/providers/appointment_doctor_provider.dart';
import 'package:med_app_mobile/providers/appointment_hour_provider.dart';
import 'package:med_app_mobile/providers/appointment_type_provider.dart';

typedef VoidFunction = void Function();

class AppointmentResHelper {
  static stepperAction(
    AppointmentDoctorProvider appointmentDoctorProv,
    AppointmentHourProvider appointmentHourProv,
    AppointmentTypeProvider appointmentTypeProvider,
    BuildContext context,
    VoidFunction onStepContinue,
    UserPatient user,
  ) {
    return () {
      appointmentDoctorProv.activeStepIndex == 0
          ? {
              if (appointmentTypeProvider.selectedType == -1)
                {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => const AlertWindow(
                      title: 'Error',
                      message: 'You have to choose an appointment type!',
                    ),
                  )
                }
              else
                {onStepContinue()}
            }
          : appointmentDoctorProv.activeStepIndex == 1
              ? {
                  if (appointmentDoctorProv.selectedDoctor == -1)
                    {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => const AlertWindow(
                          title: 'Error',
                          message: 'You have to choose a doctor!',
                        ),
                      )
                    }
                  else
                    {onStepContinue()}
                }
              : appointmentDoctorProv.activeStepIndex == 2
                  ? {
                      if (appointmentHourProv.selectedHour
                              .compareTo(const Duration(minutes: 0)) ==
                          0)
                        {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                const AlertWindow(
                              title: 'Error',
                              message: 'You have to choose an hour!',
                            ),
                          )
                        }
                      else
                        {onStepContinue()}
                    }
                  : {
                      confirm(
                        appointmentDoctorProv,
                        appointmentHourProv,
                        appointmentTypeProvider,
                        context,
                        user,
                        appointmentTypeProvider.editing,
                      )
                    };
    };
  }

  static cancelAppReserving(
    AppointmentDoctorProvider appointmentDoctorProv,
    AppointmentHourProvider appointmentHourProv,
    AppointmentTypeProvider appointmentTypeProvider,
    BuildContext context,
  ) {
    appointmentHourProv.selctHour(
        const Duration(minutes: 0), const Duration(minutes: 0));
    appointmentHourProv.setDate("");
    appointmentHourProv.setIsNFZ(false);
    appointmentHourProv.setAppointmentIdForEditing('');
    appointmentHourProv.setOldDateForEditing('');
    appointmentDoctorProv.selctDoctor(-1);
    appointmentDoctorProv.setDoctor(null);
    appointmentDoctorProv.setActiveStepIndex(0);
    appointmentDoctorProv.setAppointmentType(null);
    appointmentTypeProvider.selectAppType(-1);
    appointmentTypeProvider.setEditing(false);
    appointmentTypeProvider.setAppointmentCategoryId('');
    appointmentTypeProvider.setPrevAppointment(null);
    appointmentTypeProvider.setPrevNfz(false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) {
        return const MainPage();
      }),
    );
  }
}

void confirm(
  AppointmentDoctorProvider appointmentDoctorProv,
  AppointmentHourProvider appointmentHourProv,
  AppointmentTypeProvider appointmentTypeProvider,
  BuildContext context,
  UserPatient user,
  bool editing,
) async {
  if (editing) {
    await appointmentHourProv.updateAppointment(
      patientId: FirebaseAuth.instance.currentUser!.uid,
      patientName: user.name,
      title: appointmentDoctorProv.appointmentType!.name,
      doctorId: appointmentDoctorProv.doctor!.id,
      doctorName: appointmentDoctorProv.doctor!.name,
      date: appointmentHourProv.date,
      hour: appointmentHourProv.selectedHour,
      length: appointmentDoctorProv.appointmentType!.estimatedTime,
      endHour: appointmentHourProv.endHour,
      price: appointmentHourProv.isNFZ
          ? null
          : appointmentDoctorProv.appointmentType!.cost,
    );
  } else {
    // Save edit function
    await appointmentHourProv.reserveAppointment(
      patientId: FirebaseAuth.instance.currentUser!.uid,
      patientName: user.name,
      title: appointmentDoctorProv.appointmentType!.name,
      doctorId: appointmentDoctorProv.doctor!.id,
      doctorName: appointmentDoctorProv.doctor!.name,
      date: appointmentHourProv.date,
      hour: appointmentHourProv.selectedHour,
      length: appointmentDoctorProv.appointmentType!.estimatedTime,
      endHour: appointmentHourProv.endHour,
      price: appointmentHourProv.isNFZ
          ? null
          : appointmentDoctorProv.appointmentType!.cost,
    );
  }

  appointmentHourProv.selctHour(
      const Duration(minutes: 0), const Duration(minutes: 0));
  appointmentHourProv.setDate("");
  appointmentHourProv.setIsNFZ(false);
  appointmentHourProv.setAppointmentIdForEditing('');
  appointmentHourProv.setOldDateForEditing('');
  appointmentDoctorProv.selctDoctor(-1);
  appointmentDoctorProv.setDoctor(null);
  appointmentDoctorProv.setActiveStepIndex(0);
  appointmentDoctorProv.setAppointmentType(null);
  appointmentTypeProvider.selectAppType(-1);
  appointmentTypeProvider.setEditing(false);
  appointmentTypeProvider.setAppointmentCategoryId('');
  appointmentTypeProvider.setPrevAppointment(null);
  appointmentTypeProvider.setPrevNfz(false);
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context) {
      return const MainPage();
    }),
  );
}
