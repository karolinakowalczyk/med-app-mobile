import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/text_fields_dialog.dart';
import 'package:med_app_mobile/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class PhoneProvidingPage extends StatelessWidget {
  const PhoneProvidingPage({Key? key}) : super(key: key);

  Future<String?> providePhoneNumber(BuildContext context) async {
    String? phoneNumber = await showDialog<String>(
      context: context,
      builder: (context) {
        TextEditingController _textEditingController =
            TextEditingController(text: '');
        final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
        return TextFieldAlertDialogHelper().mainAlertDialog(
          context: context,
          title: 'Please enter phone number for better contact!',
          actions: [
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    // Invalid!
                    return;
                  }
                  Navigator.of(context).pop(_textEditingController.text);
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
          labelText: 'Phone number',
          hintText: 'Enter phone number',
          textFieldController: _textEditingController,
          formKey: _formKey,
          validator: (value) {
            if (value!.isNotEmpty && value.length < 9) {
              return 'Phone number must contains 9 digits.';
              // ignore: unnecessary_null_comparison
            } else if (value == null) {
              return null;
            } else if (!isNumeric(value)) {
              return 'Phone number must contains only digits.';
            }
            return null;
          },
        );
      },
    );
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      await Provider.of<AuthServices>(context, listen: false)
          .updatePhoneNumber(phoneNumber);
    }

    return phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    final authServicesProvider = Provider.of<AuthServices>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Registration app',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Do you want to provide a phone number for better contact?',
              style: TextStyle(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 100,
                  child: TextButton(
                    onPressed: () {
                      authServicesProvider.setIsPhoneNumberDefined(true);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      primary: Colors.white,
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text(
                      'Later',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () async {
                      await providePhoneNumber(context);
                      authServicesProvider.setIsPhoneNumberDefined(true);
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              //   ),
              // ),
              // ],
            ),
          ],
        ),
      ),
    );
  }
}
