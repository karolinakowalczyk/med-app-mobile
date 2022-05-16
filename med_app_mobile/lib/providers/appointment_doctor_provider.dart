import 'package:flutter/material.dart';
import 'package:med_app_mobile/models/doctor_model.dart';

class AppointmentDoctorProvider extends ChangeNotifier {
  int _activeStepIndex = 0;
  int _selectedDoctor = -1;
  Doctor? _doctor;

  int get selectedDoctor => _selectedDoctor;

  void selctDoctor(int i) {
    if (_selectedDoctor == i) {
      _selectedDoctor = -1;
      _doctor = null;
    } else {
      _selectedDoctor = i;
    }
    notifyListeners();
  }

  Doctor? get doctor => _doctor;

  void setDoctor(Doctor? doc) {
    _doctor = doc;
  }

  int get activeStepIndex => _activeStepIndex;

  void setActiveStepIndex(int i) {
    _activeStepIndex = i;
    notifyListeners();
  }
}
