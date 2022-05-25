import 'package:flutter/foundation.dart';
import 'package:med_app_mobile/models/appointment_type.dart';

class AppointmentTypeProvider extends ChangeNotifier {
  String _appointmentTypeId = '';
  // AppointmentType? _appointmentType;
  int _selectedType = -1;

  int get selectedType => _selectedType;

  String get appointmentTypeId => _appointmentTypeId;
  // AppointmentType? get appointmentType => _appointmentType;

  void setAppointmentCategoryId(String appTypeId) {
    _appointmentTypeId = appTypeId;
  }

  void selectAppType(int i) {
    if (_selectedType == i) {
      _selectedType = -1;
      _appointmentTypeId = '';
    } else {
      _selectedType = i;
    }
    notifyListeners();
  }
}
