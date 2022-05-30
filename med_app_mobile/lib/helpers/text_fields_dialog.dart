import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/theme_helper.dart';

class TextFieldAlertDialogHelper {
  AlertDialog mainAlertDialog({
    required BuildContext context,
    required String title,
    required String labelText,
    required String hintText,
    required List<Widget> actions,
    required TextEditingController textFieldController,
    required Key formKey,
    required String? Function(String?) validator,
  }) {
    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: textFieldController,
          keyboardType: TextInputType.number,
          maxLength: 9,
          validator: validator,
          decoration: ThemeHelper().textInputDecoration(
            labelText,
            hintText,
          ),
        ),
      ),
      actions: actions,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(32.0),
        ),
      ),
    );
  }
}
