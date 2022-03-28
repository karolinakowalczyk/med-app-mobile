import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:med_app_mobile/helpers/theme_helper.dart';

import 'main_page.dart';

/* Strona rejestracji - trzeba dodać logiki sprawdzające np. czy numer telefonu ma 9 cyfr,
czy e-mail jest 'normalny', czy Terms&Regul jest zaznaczone itp. */
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> with RestorationMixin{

  final _formKey = GlobalKey<FormState>();
  RestorableBoolN checkboxValue = RestorableBoolN(false);

  @override
  String get restorationId => 'checkbox';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(checkboxValue, restorationId);
  }

  @override
  void dispose() {
    checkboxValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Text(
                    'Create account',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          child: TextField(
                            decoration: ThemeHelper().textInputDecoration('Name', 'Enter your name'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          // Tu trzeba sprawdzić czy e-mail jest 'normalny'
                          child: TextField(
                            decoration: ThemeHelper().textInputDecoration('E-mail adress', 'Enter your e-mail adress'),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          // Tu trzeba sprawdzić czy numer ma 9 cyfr
                          child: TextField(
                            decoration: ThemeHelper().textInputDecoration('Phone number', 'Enter your phone number'),
                            keyboardType: TextInputType.phone,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          child: TextField(
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration('Password', 'Enter your password'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          // Tu trzeba sprawdzić czy hasło takie samo jak poprzednie
                          child: TextField(
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration('Confirm password', 'Confirm your password'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        FormField<bool>(
                          builder: (state) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: checkboxValue.value,
                                      onChanged: (value) {
                                        setState(() {
                                          checkboxValue.value = value;
                                          state.didChange(value);
                                        });
                                      },
                                    ),
                                    const Text(
                                      'I accept all terms and conditions',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          validator: (value) {
                            // Tutaj IF który sprawdzi czy Terms&Cond są zaznaczone
                          },
                        ),
                        const SizedBox(width: 20),
                        Container(
                          // To jest przycisk tworzący konto, podpiać bezę danych
                          decoration: ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const MainPage(),
                                  ), 
                                  (Route<dynamic> route) => false);
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                'Create account',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}