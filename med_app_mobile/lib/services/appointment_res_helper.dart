import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/alert_window_helper.dart';
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
                              message: 'You have to choose an hour',
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
    appointmentDoctorProv.selctDoctor(-1);
    appointmentDoctorProv.setDoctor(null);
    appointmentDoctorProv.setActiveStepIndex(0);
    appointmentTypeProvider.selectAppType(-1);
    appointmentTypeProvider.setAppointmentCategoryId('');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) {
        return const MainPage();
      }),
    );
  }

  static editAppointment(
    AppointmentDoctorProvider appointmentDoctorProv,
    AppointmentHourProvider appointmentHourProv,
    AppointmentTypeProvider appointmentTypeProvider,
    BuildContext context,
    String title,
    String date,
    String time,
    String doctor,
    bool editing, {
    String? appointmentId,
  }) {
    appointmentHourProv.selctHour(
        const Duration(minutes: 0), const Duration(minutes: 0));
    appointmentHourProv.setDate("");
    appointmentHourProv.setIsNFZ(false);
    appointmentDoctorProv.selctDoctor(-1);
    appointmentDoctorProv.setDoctor(null);
    appointmentDoctorProv.setActiveStepIndex(0);
    appointmentTypeProvider.selectAppType(-1);
    appointmentTypeProvider.setAppointmentCategoryId('');
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
) async {
  await appointmentHourProv.reserveAppointment(
    patientId: FirebaseAuth.instance.currentUser!.uid,
    patientName: user.name, //User here,

    title: appointmentDoctorProv.appointmentType!.name,
    doctorId: appointmentDoctorProv.doctor!.id,
    doctorName: appointmentDoctorProv.doctor!.name,
    date: appointmentHourProv.date,
    hour: appointmentHourProv.selectedHour,
    length: appointmentDoctorProv.appointmentType!.estimatedTime,
    endHour: appointmentHourProv.endHour,
  );
  appointmentHourProv.selctHour(
      const Duration(minutes: 0), const Duration(minutes: 0));
  appointmentHourProv.setDate("");
  appointmentHourProv.setIsNFZ(false);
  appointmentDoctorProv.selctDoctor(-1);
  appointmentDoctorProv.setDoctor(null);
  appointmentDoctorProv.setActiveStepIndex(0);
  appointmentTypeProvider.selectAppType(-1);
  appointmentDoctorProv.setAppointmentType(null);
  appointmentTypeProvider.setAppointmentCategoryId('');
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context) {
      return const MainPage();
    }),
  );
}
