import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/text_fields_dialog.dart';
import 'package:med_app_mobile/pages/main_page.dart';
import 'package:med_app_mobile/pages/phone_providing_page.dart';
import 'package:med_app_mobile/providers/main_page_provider.dart';
import 'package:med_app_mobile/services/auth.dart';
import 'package:provider/provider.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authServicesProvider = Provider.of<AuthServices>(context);
    if (!authServicesProvider.isPhoneNumberDefined) {
      return const PhoneProvidingPage();
    } else {
      return const MainPage();
    }
  }
}
