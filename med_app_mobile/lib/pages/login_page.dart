import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/theme_helper.dart';
import 'package:med_app_mobile/services/auth.dart';
import 'package:validators/validators.dart';

import 'registration_page.dart';

/* Strona logowania - trzeba dodać logikę do przycisku 'Remember me', dodać logikę
wysyłającą do odpowiedniego konta itp. */
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with RestorationMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RestorableBoolN checkboxValue = RestorableBoolN(false);
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isLoading = false;
  final AuthServices _auth = AuthServices();

  @override
  String get restorationId => 'checkbox';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(checkboxValue, restorationId);
  }

  @override
  void dispose() {
    checkboxValue.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await _auth.signIn(
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
        child: Column(
          children: [
            SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 80),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            child: TextFormField(
                              decoration: ThemeHelper().textInputDecoration(
                                  'E-mail adress', 'Enter your e-mail adress'),
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email address';
                                } else if (!isEmail(value)) {
                                  return 'Please enter valid email address';
                                }
                                return null;
                              },
                            ),
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            child: TextFormField(
                              obscureText: true,
                              decoration: ThemeHelper().textInputDecoration(
                                  'Password', 'Enter your password'),
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter phone number';
                                }
                                return null;
                              },
                            ),
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            // Checkbox od zapamiętania użytkownika, trzeba to jakoś oprogramować
                            margin: const EdgeInsets.fromLTRB(0, 0, 10, 20),
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: <Widget>[
                                Checkbox(
                                  value: checkboxValue.value,
                                  onChanged: (value) {
                                    setState(() {
                                      checkboxValue.value = value;
                                    });
                                  },
                                ),
                                const Text(
                                  'Remember me',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          !_isLoading
                              ? Container(
                                  // Przycisk logujący do konta na podstawie hasła i e-maila
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  decoration: ThemeHelper()
                                      .buttonBoxDecoration(context),
                                  child: ElevatedButton(
                                    style: ThemeHelper().buttonStyle(),
                                    onPressed: () async {
                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             const MainPage()));
                                      await login();
                                    },
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(40, 10, 40, 10),
                                      child: Text(
                                        'Login',
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
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: const CircularProgressIndicator(),
                                ),
                          Container(
                            // Przycisk wysyłający do rejestracji, chyba nic nie trzeba dodawać
                            margin: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrationPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Create account',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const Text(
                            '--------------- Or sign in with ----------------',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(width: 30),
                          Container(
                            // Przycisk do providera od Googla - oprogramować
                            margin: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                            decoration: ThemeHelper()
                                .buttonBoxDecoration(context, '#FFFFFF'),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              onPressed: () async {
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             const MainPage()));
                                await _auth.signInWithGoogle();
                              },
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  'Google',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
