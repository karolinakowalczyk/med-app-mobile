import 'package:flutter/foundation.dart';
import 'package:med_app_mobile/models/appointment_model.dart';

class AppointmentTypeProvider extends ChangeNotifier {
  String _appointmentTypeId = '';
  // AppointmentType? _appointmentType;
  int _selectedType = -1;
  bool _editing = false;
  bool _prevNfz = false;
  Appointment? _prevAppointment;

  int get selectedType => _selectedType;

  String get appointmentTypeId => _appointmentTypeId;

  bool get editing => _editing;

  bool get prevNfz => _prevNfz;

  Appointment? get prevAppointment => _prevAppointment;

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

  void setEditing(bool edt) {
    _editing = edt;
  }

  void setPrevNfz(bool nfz) {
    _prevNfz = nfz;
  }

  void setPrevAppointment(Appointment app) {
    _prevAppointment = app;
  }
}
