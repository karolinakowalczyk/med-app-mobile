import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/drawer_helper.dart';
import 'package:med_app_mobile/pages/choose_date_page.dart';
import 'package:med_app_mobile/pages/choose_doctor_page.dart';
import 'package:med_app_mobile/pages/confirm_page.dart';
import 'package:med_app_mobile/services/auth.dart';

// Ta klasa odpowiada za umawianie i edytowanie wizyt
class AppointManagerPage extends StatefulWidget {
  const AppointManagerPage({Key? key}) : super(key: key);

  @override
  State<AppointManagerPage> createState() => _AppointManagerPageState();
}

class _AppointManagerPageState extends State<AppointManagerPage> {
  final AuthServices _auth = AuthServices();
  int _activeStepIndex = 0;

  // Lista kroków zaplanowania wizyty
  List<Step> stepList() => [
        Step(
            title: const Text('Doctor'),
            state:
                _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 0,
            content: const Center(
              child: ChooseDoctorPage(),
            )),
        Step(
            title: const Text('Date'),
            state:
                _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 1,
            content: const Center(
              child: ChooseDatePage(),
            )),
        Step(
            title: const Text('Confirm'),
            state:
                _activeStepIndex <= 2 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 2,
            content: const Center(
              child: ConfirmPage(),
            ))
      ];

  @override
  Widget build(BuildContext context) {
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
           wylogowanie do Drawer'a */
            IconButton(
                onPressed: () => _auth.signOut(),
                icon: const Icon(
                  Icons.logout,
                )),
          ],
        ),
        drawer: const DrawerHelper(),
        // TODO: kolejne kroki powinny być możliwe tylko po spełnieniu wymagań
        // np. wybranie lekarza, dnia i godziny
        body: Stepper(
          type: StepperType.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          currentStep: _activeStepIndex,
          steps: stepList(),
          onStepContinue: () {
            if (_activeStepIndex < (stepList().length - 1)) {
              _activeStepIndex++;
            }
            setState(() {});
          },
          onStepCancel: () {
            if (_activeStepIndex == 0) {
              return;
            }
            _activeStepIndex--;
            setState(() {});
          },
          // TODO: ARTUR - fajnie by było gdyby poniższe przyciski były zawsze na dole strony
          // a nie są, ja już nie mam pomysłów, może ty coś zdziałasz
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            final isLastStep = _activeStepIndex == stepList().length - 1;

            return Container(
              margin: const EdgeInsets.only(top: 12),
              child: Row(
                children: <Widget>[
                  if (_activeStepIndex > 0)
                    Expanded(
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
                                    Colors.redAccent)))),
                  const SizedBox(width: 50),
                  // TODO: po wciśnięciu "Confirm" wracamy do Home -> Appointments
                  // i dodajemy nową utworzoną wizytę
                  Expanded(
                      child: ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: (isLastStep)
                              ? const Text('Confirm')
                              : const Text('Next'),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          )))),
                ],
              ),
            );
          },
        ));
  }
}
