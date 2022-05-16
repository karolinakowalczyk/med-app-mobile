import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/alert_window_helper.dart';
import 'package:med_app_mobile/pages/authentication.dart';
import 'package:validators/validators.dart';
import 'package:med_app_mobile/helpers/theme_helper.dart';
import 'package:med_app_mobile/services/auth.dart';

/* Strona rejestracji - trzeba dodać logiki sprawdzające np. czy numer telefonu ma 9 cyfr,
czy e-mail jest 'normalny', czy Terms&Regul jest zaznaczone itp. */
class RegistrationPage extends StatefulWidget {
  final Function changeAuthMode;
  const RegistrationPage(this.changeAuthMode, {Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>
    with RestorationMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RestorableBoolN checkboxValue = RestorableBoolN(false);
  var _isLoading = false;
  final AuthServices _auth = AuthServices();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  String get restorationId => 'checkbox';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(checkboxValue, restorationId);
  }

  @override
  void dispose() {
    checkboxValue.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    if (checkboxValue.value != null) {
      if (checkboxValue.value == false) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => const AlertWindow(
            title: 'Attention',
            message: 'You have to accept condition terms',
          ),
        );
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });
    try {
      await _auth.signUp(
        _nameController.text.trim(),
        _phoneController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
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
                      fontSize: 40,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          child: TextFormField(
                            decoration: ThemeHelper()
                                .textInputDecoration('Name', 'Enter your name'),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !isAlpha(value.replaceAll(' ', ''))) {
                                return 'Please enter full name';
                              }
                              return null;
                            },
                            controller: _nameController,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration(
                                'E-mail adress', 'Enter your e-mail adress'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email address';
                              } else if (!isEmail(value)) {
                                return 'Please enter valid email address';
                              }
                              return null;
                            },
                            controller: _emailController,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration(
                                'Phone number', 'Enter your phone number'),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter phone number';
                              } else if (!isNumeric(
                                  value.replaceAll('+', ''))) {
                                return 'Please enter valid phone number';
                              }
                              return null;
                            },
                            controller: _phoneController,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          child: TextFormField(
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                'Password', 'Enter your password'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              } else if (value.length < 7) {
                                return 'Password must contain at least 7 characters';
                              }
                              return null;
                            },
                            controller: _passwordController,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          child: TextFormField(
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                'Confirm password', 'Confirm your password'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              } else if (value.length < 7) {
                                return 'Password must contain at least 7 characters';
                              } else if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
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
                                    // TODO: stworzyć ostrzeżenie o braku zaznaczenia checkboxa
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
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(width: 20),
                        !_isLoading
                            ? Container(
                                // Przycisk tworzący konto
                                decoration:
                                    ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  onPressed: () async {
                                    // if (_formKey.currentState!.validate()) {
                                    //   Navigator.of(context).pushAndRemoveUntil(
                                    //       MaterialPageRoute(
                                    //         builder: (context) => const MainPage(),
                                    //       ),
                                    //       (Route<dynamic> route) => false);
                                    // }
                                    await register();
                                  },
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
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
                              )
                            : Container(
                                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: const CircularProgressIndicator(),
                              ),
                        Container(
                          // Przycisk wysyłający do logowania
                          margin: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              widget.changeAuthMode(AuthModes.login);
                            },
                            child: Text(
                              'Login instead',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
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
