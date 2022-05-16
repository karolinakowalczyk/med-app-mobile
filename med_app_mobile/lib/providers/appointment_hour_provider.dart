import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentHourProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _baseAvailableAppointments = [
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
  ];
  // ignore: prefer_final_fields
  List<String> _availableAppointments = [];
  var _selectedHour = 'Not selected';
  var _endHour = 'Not known';
  late String _date = DateFormat('dd-MM-yyy').format(DateTime.now());

  String get selectedHour => _selectedHour;
  String get endHour => _endHour;

  void selctHour(String i, String end) {
    if (_selectedHour == i) {
      _selectedHour = 'Not selected';
      _endHour = 'Not known';
    } else {
      _selectedHour = i;
      _endHour = end;
    }
    notifyListeners();
  }

  String get date => _date;

  void setDate(String newDate) {
    _date = newDate;
  }

  Stream<List<String>> availableAppointments(String day, String doctorId) {
    _availableAppointments.clear();
    _availableAppointments.addAll(_baseAvailableAppointments);
    return _firestore
        .collection('appointments')
        .doc(day)
        .collection('appointments')
        .where('doctor', isEqualTo: doctorId)
        .snapshots()
        .asyncMap(
      (appointments) {
        for (var app in appointments.docs) {
          _availableAppointments.remove(app.data()['hour']);
        }
        return _availableAppointments;
      },
    );
  }

  List<String> getAppointments() {
    return _availableAppointments;
  }

  Future<void> reserveAppointment({
    required String patientId,
    required String patientName,
    required String title,
    required String doctorId,
    required String doctorName,
    required String date,
    required String hour,
    required String endHour,
  }) async {
    final result = await _firestore
        .collection('appointments')
        .doc(date)
        .collection('appointments')
        .add({
      'title': title,
      'doctor': doctorId,
      'doctorName': doctorName,
      'hour': hour,
      'endHour': endHour,
      'date': date,
      'patient': patientId,
      'patientName': patientName,
    });
    await _firestore
        .collection('patients')
        .doc(patientId)
        .collection('appointments')
        .add({
      'date': date,
      'id': result.id,
    });
  }
}
