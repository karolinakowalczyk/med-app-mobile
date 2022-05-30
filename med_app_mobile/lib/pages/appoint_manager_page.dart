import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/drawer_helper.dart';
import 'package:med_app_mobile/models/appointment_type.dart';
import 'package:med_app_mobile/models/doctor_model.dart';
import 'package:med_app_mobile/pages/choose_app_type_page.dart';
import 'package:med_app_mobile/pages/choose_date_page.dart';
import 'package:med_app_mobile/pages/choose_doctor_page.dart';
import 'package:med_app_mobile/pages/confirm_page.dart';
import 'package:med_app_mobile/providers/appointment_doctor_provider.dart';
import 'package:med_app_mobile/providers/appointment_hour_provider.dart';
import 'package:med_app_mobile/providers/appointment_type_provider.dart';
import 'package:med_app_mobile/providers/user_provider.dart';
import 'package:med_app_mobile/services/appointment_res_helper.dart';
import 'package:provider/provider.dart';

// Ta klasa odpowiada za umawianie i edytowanie wizyt
class AppointManagerPage extends StatelessWidget {
  final Stream<List<Doctor>> doctorsStream;
  // final Stream<List<AppointmentType>> appTypeStream;
  final Stream<List<AppointmentCategory>> appCategoriesStream;
  const AppointManagerPage({
    required this.appCategoriesStream,
    required this.doctorsStream,
    Key? key,
  }) : super(key: key);

  // Lista kroków zaplanowania wizyty
  List<Step> stepList(
    AppointmentDoctorProvider prov,
    double remainHeigth,
  ) =>
      [
        Step(
          title: const Text('Type'),
          state: prov.activeStepIndex <= 0
              ? StepState.editing
              : StepState.complete,
          isActive: prov.activeStepIndex >= 0,
          content: Center(
            child: ChooseAppTypePage(remainHeigth: remainHeigth),
          ),
        ),
        Step(
          title: const Text('Doctor'),
          state: prov.activeStepIndex <= 1
              ? StepState.editing
              : StepState.complete,
          isActive: prov.activeStepIndex >= 1,
          content: Center(
            child: ChooseDoctorPage(remainHeigth: remainHeigth),
          ),
        ),
        Step(
          title: const Text('Date'),
          state: prov.activeStepIndex <= 2
              ? StepState.editing
              : StepState.complete,
          isActive: prov.activeStepIndex >= 2,
          content: Center(
            child: ChooseDatePage(remainHeigth: remainHeigth),
          ),
        ),
        Step(
          title: const Text('Confirm'),
          state: prov.activeStepIndex <= 3
              ? StepState.editing
              : StepState.complete,
          isActive: prov.activeStepIndex >= 3,
          content: Center(
            child: ConfirmPage(remainHeigth: remainHeigth),
          ),
        )
      ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final appointmentDoctorProv =
        Provider.of<AppointmentDoctorProvider>(context, listen: false);
    final appointmentHourProv =
        Provider.of<AppointmentHourProvider>(context, listen: false);
    final appointmentTypeProv =
        Provider.of<AppointmentTypeProvider>(context, listen: false);
    final appBar = AppBar(
      title: const Text(
        'Registration app',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
    return Scaffold(
      appBar: appBar,
      drawer: const DrawerHelper(),
      // Kolejne kroki powinny być możliwe tylko po spełnieniu wymagań
      // np. wybranie lekarza, dnia i godziny
      body: StreamBuilder<List<Doctor>>(
        stream: doctorsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream: appCategoriesStream,
            builder: (context2, snapshot2) {
              if (snapshot2.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height - appBar.preferredSize.height,
                  maxHeight: size.height - appBar.preferredSize.height,
                ),
                child: Consumer<AppointmentDoctorProvider>(
                  builder: (_, value, __) => Stepper(
                    margin: EdgeInsets.zero,
                    type: StepperType.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    currentStep: appointmentDoctorProv.activeStepIndex,
                    steps: stepList(
                      appointmentDoctorProv,
                      size.height - appBar.preferredSize.height,
                    ),
                    onStepContinue: () {
                      if (appointmentDoctorProv.activeStepIndex <
                          (stepList(
                                appointmentDoctorProv,
                                size.height - appBar.preferredSize.height,
                              ).length -
                              1)) {
                        appointmentDoctorProv.setActiveStepIndex(
                            appointmentDoctorProv.activeStepIndex + 1);
                      }
                    },
                    onStepCancel: () {
                      if (appointmentDoctorProv.activeStepIndex == 0) {
                        return;
                      }
                      appointmentDoctorProv.setActiveStepIndex(
                          appointmentDoctorProv.activeStepIndex - 1);
                    },
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                      final isLastStep =
                          appointmentDoctorProv.activeStepIndex ==
                              stepList(
                                    appointmentDoctorProv,
                                    size.height - appBar.preferredSize.height,
                                  ).length -
                                  1;
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            if (appointmentDoctorProv.activeStepIndex > 0)
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: size.width / 3,
                                  minHeight: 45,
                                  maxHeight: 45,
                                ),
                                child: ElevatedButton(
                                  onPressed: details.onStepCancel,
                                  child: const Text('Back'),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.redAccent),
                                  ),
                                ),
                              ),
                            // Po wciśnięciu "Confirm" wracamy do Home -> Appointments
                            // i dodajemy nową utworzoną wizytę
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth:
                                    appointmentDoctorProv.activeStepIndex == 0
                                        ? size.width / 2
                                        : size.width / 3,
                                minHeight: 45,
                              ),
                              child: ElevatedButton(
                                onPressed: AppointmentResHelper.stepperAction(
                                  appointmentDoctorProv,
                                  appointmentHourProv,
                                  appointmentTypeProv,
                                  context,
                                  () => details.onStepContinue!(),
                                  user!,
                                ),
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
              );
            },
          );
        },
      ),
    );
  }
}
