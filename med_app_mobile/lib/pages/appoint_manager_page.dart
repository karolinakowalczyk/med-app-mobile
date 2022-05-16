import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/alert_window_helper.dart';
import 'package:med_app_mobile/helpers/drawer_helper.dart';
import 'package:med_app_mobile/models/doctor_model.dart';
import 'package:med_app_mobile/pages/choose_date_page.dart';
import 'package:med_app_mobile/pages/choose_doctor_page.dart';
import 'package:med_app_mobile/pages/confirm_page.dart';
import 'package:med_app_mobile/pages/main_page.dart';
import 'package:med_app_mobile/providers/appointment_doctor_provider.dart';
import 'package:med_app_mobile/providers/appointment_hour_provider.dart';
import 'package:med_app_mobile/providers/doctors_data_provider.dart';
import 'package:med_app_mobile/providers/user_provider.dart';
import 'package:med_app_mobile/services/auth.dart';
import 'package:provider/provider.dart';

// Ta klasa odpowiada za umawianie i edytowanie wizyt
class AppointManagerPage extends StatelessWidget {
  final Stream<List<Doctor>> doctorsStream;
  const AppointManagerPage({required this.doctorsStream, Key? key})
      : super(key: key);

  // Lista kroków zaplanowania wizyty
  List<Step> stepList(AppointmentDoctorProvider prov) => [
        Step(
          title: const Text('Doctor'),
          state: prov.activeStepIndex <= 0
              ? StepState.editing
              : StepState.complete,
          isActive: prov.activeStepIndex >= 0,
          content: const Center(
            child: ChooseDoctorPage(),
          ),
        ),
        Step(
          title: const Text('Date'),
          state: prov.activeStepIndex <= 1
              ? StepState.editing
              : StepState.complete,
          isActive: prov.activeStepIndex >= 1,
          content: const Center(
            child: ChooseDatePage(),
          ),
        ),
        Step(
          title: const Text('Confirm'),
          state: prov.activeStepIndex <= 2
              ? StepState.editing
              : StepState.complete,
          isActive: prov.activeStepIndex >= 2,
          content: const Center(
            child: ConfirmPage(),
          ),
        )
      ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final appontmentDoctorProv =
        Provider.of<AppointmentDoctorProvider>(context, listen: false);
    final appontmentHourProv =
        Provider.of<AppointmentHourProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registration app',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          /* TODO: to ma być przycisk do powiadomień ale przedtem trzeba wrzucić
           wylogowanie do Drawer'a 
           DONE
          */
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
            ),
          ),
        ],
      ),
      drawer: const DrawerHelper(),
      // TODO: kolejne kroki powinny być możliwe tylko po spełnieniu wymagań
      // np. wybranie lekarza, dnia i godziny
      body: StreamBuilder<List<Doctor>>(
        stream: doctorsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              height: size.height * 0.92,
              child: Consumer<AppointmentDoctorProvider>(
                builder: (_, value, __) => Stepper(
                  margin: EdgeInsets.zero,
                  type: StepperType.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  currentStep: appontmentDoctorProv.activeStepIndex,
                  steps: stepList(appontmentDoctorProv),
                  onStepContinue: () {
                    if (appontmentDoctorProv.activeStepIndex <
                        (stepList(appontmentDoctorProv).length - 1)) {
                      appontmentDoctorProv.setActiveStepIndex(
                          appontmentDoctorProv.activeStepIndex + 1);
                    }
                  },
                  onStepCancel: () {
                    if (appontmentDoctorProv.activeStepIndex == 0) {
                      return;
                    }
                    appontmentDoctorProv.setActiveStepIndex(
                        appontmentDoctorProv.activeStepIndex - 1);
                  },
                  // TODO: ARTUR - fajnie by było gdyby poniższe przyciski były zawsze na dole strony
                  // a nie są, ja już nie mam pomysłów, może ty coś zdziałasz
                  controlsBuilder:
                      (BuildContext context, ControlsDetails details) {
                    final isLastStep = appontmentDoctorProv.activeStepIndex ==
                        stepList(appontmentDoctorProv).length - 1;
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          if (appontmentDoctorProv.activeStepIndex > 0)
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: size.width / 3,
                                minHeight: 45,
                              ),
                              child: ElevatedButton(
                                onPressed: details.onStepCancel,
                                child: const Text('Back'),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.redAccent),
                                ),
                              ),
                            ),
                          // TODO: po wciśnięciu "Confirm" wracamy do Home -> Appointments
                          // i dodajemy nową utworzoną wizytę
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth:
                                  appontmentDoctorProv.activeStepIndex == 0
                                      ? size.width / 2
                                      : size.width / 3,
                              minHeight: 45,
                            ),
                            child: ElevatedButton(
                              onPressed: appontmentDoctorProv.activeStepIndex ==
                                      0
                                  ? () {
                                      if (appontmentDoctorProv.selectedDoctor ==
                                          -1) {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              const AlertWindow(
                                            title: 'Error',
                                            message:
                                                'You have to choose a doctor',
                                          ),
                                        );
                                      } else {
                                        details.onStepContinue!();
                                      }
                                    }
                                  : appontmentDoctorProv.activeStepIndex == 1
                                      ? () {
                                          if (appontmentHourProv.selectedHour ==
                                              'Not selected') {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  const AlertWindow(
                                                title: 'Error',
                                                message:
                                                    'You have to choose an hour',
                                              ),
                                            );
                                          } else {
                                            details.onStepContinue!();
                                          }
                                        }
                                      : () async {
                                          await appontmentHourProv
                                              .reserveAppointment(
                                            patientId: FirebaseAuth
                                                .instance.currentUser!.uid,
                                            patientName:
                                                user!.name, //User here,

                                            title: 'Plasceholder',
                                            doctorId:
                                                appontmentDoctorProv.doctor!.id,
                                            doctorName: appontmentDoctorProv
                                                .doctor!.name,
                                            date: appontmentHourProv.date,

                                            hour:
                                                appontmentHourProv.selectedHour,
                                            endHour: appontmentHourProv.endHour,
                                          );
                                          appontmentHourProv.selctHour(
                                              'Not selected', 'Not known');
                                          appontmentHourProv.setDate("");
                                          appontmentDoctorProv.selctDoctor(-1);
                                          appontmentDoctorProv.setDoctor(null);
                                          appontmentDoctorProv
                                              .setActiveStepIndex(0);
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                              return const MainPage();
                                            }),
                                          );
                                        },
                              child: (isLastStep)
                                  ? const Text('Confirm')
                                  : const Text('Next'),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
