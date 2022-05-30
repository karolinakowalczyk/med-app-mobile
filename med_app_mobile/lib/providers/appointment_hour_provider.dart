import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentHourProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  var startingHour = const Duration(hours: 8);
  final List<Duration> _baseAvailableAppointments = [];
  bool _isNFZ = false;
  String? _oldDateForEditing;
  String? _appointmentIdForEditing;
  bool _refresh = true;

  String? get oldDateForEditing => _oldDateForEditing;

  void setOldDateForEditing(String? date) {
    _oldDateForEditing = date;
  }

  String? get appointmentIdForEditing => _appointmentIdForEditing;

  void setAppointmentIdForEditing(String id) {
    if (_appointmentIdForEditing == id) {
      _appointmentIdForEditing = null;
    } else {
      _appointmentIdForEditing = id;
    }
  }

  bool get isNFZ => _isNFZ;

  void setIsNFZ(bool isNfz) {
    _isNFZ = isNfz;
    notifyListeners();
  }

  bool get refresh => _refresh;

  void setRefresh(bool refresh) {
    _refresh = refresh;
  }

  AppointmentHourProvider() {
    _baseAvailableAppointments.add(startingHour);
    for (var i = 15; i < 480; i = i + 15) {
      _baseAvailableAppointments.add(startingHour + Duration(minutes: i));
    }
  }

  String formateHour(Duration duration) {
    String minutes = (duration.inMinutes % 60 == 0)
        ? '00'
        : (duration.inMinutes % 60) < 10
            ? '0' + (duration.inMinutes % 60).toString()
            : (duration.inMinutes % 60).toString();
    String hour = duration.inHours.toString();
    if (duration.inHours < 10) {
      return '0' + hour + ':' + minutes;
    }
    return hour + ':' + minutes;
  }

  Duration stringToDuration(String hour) {
    List<String> timeElems = hour.split(':');

    return Duration(
        hours: int.parse(timeElems[0]), minutes: int.parse(timeElems[1]));
  }

  // ignore: prefer_final_fields
  List<Duration> _availableAppointments = [];
  var _selectedHour = const Duration(minutes: 0);
  var _endHour = const Duration(minutes: 0);
  late String _date = DateFormat('dd-MM-yyy').format(DateTime.now());

  Duration get selectedHour => _selectedHour;
  Duration get endHour => _endHour;

  void selctHour(Duration start, Duration end) {
    if (_selectedHour.compareTo(start) == 0) {
      _selectedHour = const Duration(minutes: 0);
      _endHour = const Duration(minutes: 0);
    } else {
      _selectedHour = start;
      _endHour = end;
    }
    notifyListeners();
  }

  String get date => _date;

  void setDate(String newDate) {
    _date = newDate;
  }

  Stream<List<Duration>> availableAppointments({
    required String day,
    required String doctorId,
    required Duration appLen,
  }) {
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
        List<Duration> toRemove = [];

        if (DateFormat('dd-MM-yyyy')
                .parse(DateFormat('dd-MM-yyyy').format(DateTime.now()))
                .compareTo(DateFormat('dd-MM-yyyy').parse(day)) ==
            0) {
          DateTime todayDate = DateFormat('dd-MM-yyyy')
              .parse(DateFormat('dd-MM-yyyy').format(DateTime.now()));
          _availableAppointments.removeWhere((element) {
            if (todayDate.add(element).isBefore(DateTime.now())) {
              return true;
            }
            return false;
          });
        }
        for (var app in appointments.docs) {
          if (app.id != _appointmentIdForEditing) {
            final len = int.parse(app.data()['length']);
            Duration length = Duration(minutes: len);

            Duration appStart = stringToDuration(app.data()['hour']);

            _availableAppointments.removeWhere((element) =>
                element.compareTo(appStart) >= 0 &&
                element.compareTo(appStart + length) < 0);

            for (var app in _availableAppointments) {
              var num = appLen.inMinutes ~/ 15 - 1;
              var mult = 1;
              for (var multi = 1; multi <= num; multi++) {
                if (!_availableAppointments
                    .contains(app + Duration(minutes: mult * 15))) {
                  toRemove.add(app);
                  break;
                }
                mult++;
              }
            }
          }
        }

        for (var index in toRemove) {
          _availableAppointments.removeWhere((element) => element == index);
        }
        return _availableAppointments;
      },
    );
  }

  List<Duration> getAppointments() {
    return _availableAppointments;
  }

  Future<void> reserveAppointment({
    required String patientId,
    required String patientName,
    required String title,
    required String doctorId,
    required String doctorName,
    required String date,
    required Duration hour,
    required int length,
    required Duration endHour,
    double? price,
  }) async {
    Map<String, dynamic> app = price != null
        ? {
            'title': title,
            'doctor': doctorId,
            'doctorName': doctorName,
            'hour': formateHour(hour),
            'endHour': formateHour(endHour),
            'length': length.toString(),
            'date': date,
            'patient': patientId,
            'patientName': patientName,
            'price': price
          }
        : {
            'title': title,
            'doctor': doctorId,
            'doctorName': doctorName,
            'hour': formateHour(hour),
            'endHour': formateHour(endHour),
            'length': length.toString(),
            'date': date,
            'patient': patientId,
            'patientName': patientName,
          };

    final result = await _firestore
        .collection('appointments')
        .doc(date)
        .collection('appointments')
        .add(app);
    await _firestore
        .collection('patients')
        .doc(patientId)
        .collection('appointments')
        .add({
      'date': date,
      'id': result.id,
    });
  }

  Future<void> updateAppointment({
    required String patientId,
    required String patientName,
    required String title,
    required String doctorId,
    required String doctorName,
    required String date,
    required Duration hour,
    required int length,
    required Duration endHour,
    double? price,
  }) async {
    Map<String, dynamic> app = price != null
        ? {
            'title': title,
            'doctor': doctorId,
            'doctorName': doctorName,
            'hour': formateHour(hour),
            'endHour': formateHour(endHour),
            'length': length.toString(),
            'date': date,
            'patient': patientId,
            'patientName': patientName,
            'price': price
          }
        : {
            'title': title,
            'doctor': doctorId,
            'doctorName': doctorName,
            'hour': formateHour(hour),
            'endHour': formateHour(endHour),
            'length': length.toString(),
            'date': date,
            'patient': patientId,
            'patientName': patientName,
          };

    DocumentReference oldAppointmentRef = _firestore
        .collection('appointments')
        .doc(_oldDateForEditing)
        .collection('appointments')
        .doc(_appointmentIdForEditing);

    DocumentReference newAppointmentRef = _firestore
        .collection('appointments')
        .doc(date)
        .collection('appointments')
        .doc(_appointmentIdForEditing);
    final appointmentsInPatient = await _firestore
        .collection('patients')
        .doc(patientId)
        .collection('appointments')
        .get();
    final appointmentInPatient = appointmentsInPatient.docs.firstWhere(
      (element) => element.data()['id'] == _appointmentIdForEditing,
    );

    DocumentReference patientAppointmentRef = _firestore
        .collection('patients')
        .doc(patientId)
        .collection('appointments')
        .doc(appointmentInPatient.id);

    await oldAppointmentRef.delete();
    await newAppointmentRef.set(app);
    await patientAppointmentRef.set({
      'date': date,
      'id': _appointmentIdForEditing,
    });
  }
}
