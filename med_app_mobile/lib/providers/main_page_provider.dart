import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_app_mobile/models/appointment_model.dart';

class MainPageProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Appointment> _patientAppointments = [];

  List<Appointment> get patientAppointments => _patientAppointments;

  Stream<List<Appointment>> appointments(String patientId) {
    _patientAppointments = [];
    return _firestore
        .collection('patients')
        .doc(patientId)
        .collection('appointments')
        .snapshots()
        .asyncMap((appointments) async {
      List<Appointment> _patientAppointments = [];
      for (var app in appointments.docs) {
        DocumentSnapshot appDoc = await _firestore
            .collection('appointments')
            .doc(app['date'])
            .collection('appointments')
            .doc(app['id'])
            .get();
        _patientAppointments.add(Appointment.fromJSON(appDoc.id, appDoc));
      }

      return _patientAppointments;
    });
  }
}
