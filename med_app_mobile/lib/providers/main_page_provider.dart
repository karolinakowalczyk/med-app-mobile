import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_app_mobile/models/appointment_model.dart';
import 'package:med_app_mobile/models/prescription_model.dart';

class MainPageProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Appointment>> appointments(String patientId) {
    return _firestore
        .collection('patients')
        .doc(patientId)
        .collection('appointments')
        .orderBy('date', descending: true)
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

  Stream<List<Prescription>> prescriptions(String patientId) {
    Map<String, String> doctors = {};
    return _firestore
        .collection('patients')
        .doc(patientId)
        .collection('prescriptions')
        .orderBy('date', descending: true)
        .snapshots()
        .asyncMap((prescriptions) async {
      List<Prescription> _patientPrescriptions = [];
      for (var presc in prescriptions.docs) {
        if (doctors.containsKey(presc['doctor'])) {
          _patientPrescriptions.add(Prescription.fromJSON(
              presc.id, presc.data(), doctors[presc['doctor']] ?? 'none'));
        } else {
          DocumentSnapshot doctorDocument =
              await _firestore.collection('doctors').doc(presc['doctor']).get();
          doctors.addAll({
            doctorDocument.id: doctorDocument['name'],
          });
          _patientPrescriptions.add(Prescription.fromJSON(
              presc.id, presc.data(), doctorDocument['name']));
        }
      }

      return _patientPrescriptions;
    });
  }

  Future<void> removePrescription(String patientId, String prescId) {
    return _firestore
        .collection('patients')
        .doc(patientId)
        .collection('prescriptions')
        .doc(prescId)
        .delete();
  }

  Future<void> removeAppointment(
    String patientId,
    String appointmentId,
    String date,
  ) {
    DocumentReference appointmentReference = FirebaseFirestore.instance
        .collection('appointments')
        .doc(date)
        .collection('appointments')
        .doc(appointmentId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // transaction.delete(appointmentReference);

      QuerySnapshot patientAppointmentReference = await FirebaseFirestore
          .instance
          .collection('patients')
          .doc(patientId)
          .collection('appointments')
          .where('id', isEqualTo: appointmentId)
          .get();

      print(patientAppointmentReference);

      // transaction.delete(patientAppointmentReference);
    });
  }

  Future<void> checkPrescriptionAsDOne(String patientId, String prescId) {
    return _firestore
        .collection('patients')
        .doc(patientId)
        .collection('prescriptions')
        .doc(prescId)
        .update({
      'done': true,
    });
  }
}
