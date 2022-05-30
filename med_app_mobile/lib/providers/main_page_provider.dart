import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_app_mobile/models/appointment_model.dart';
import 'package:med_app_mobile/models/appointment_type.dart';
import 'package:med_app_mobile/models/doctor_model.dart';
import 'package:med_app_mobile/models/prescription_model.dart';
import 'package:intl/intl.dart';
import 'package:med_app_mobile/providers/appointment_doctor_provider.dart';
import 'package:med_app_mobile/providers/appointment_hour_provider.dart';
import 'package:med_app_mobile/providers/appointment_type_provider.dart';
import 'package:med_app_mobile/providers/doctors_data_provider.dart';
import 'package:provider/provider.dart';

class MainPageProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _ifPhoneNumberProvided = false;

  bool get ifPhoneNumberProvided => _ifPhoneNumberProvided;

  void setIfPhoneNumberProvided(bool ifnumberProvided) {
    _ifPhoneNumberProvided = ifnumberProvided;
    notifyListeners();
  }

  Stream<List<Appointment>> appointments(String patientId) {
    if (patientId.isNotEmpty) {
      return _firestore
          .collection('patients')
          .doc(patientId)
          .collection('appointments')
          .orderBy('date', descending: false)
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
          _patientAppointments
              .add(Appointment.fromJSON(appDoc.id, appDoc.data()));
        }
        _patientAppointments.sort((a, b) => DateFormat('dd-MM-yyyy')
            .parse(b.date)
            .compareTo(DateFormat('dd-MM-yyyy').parse(a.date)));
        return _patientAppointments;
      });
    }
    return const Stream.empty();
  }

  Stream<List<Prescription>> prescriptions(String patientId) {
    if (patientId.isEmpty) {
      return const Stream.empty();
    }
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
      _patientPrescriptions.sort((a, b) => b.date.compareTo(a.date));
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
  ) async {
    return _firestore.runTransaction((transaction) async {
      final result = await FirebaseFirestore.instance
          .collection('patients')
          .doc(patientId)
          .collection('appointments')
          .get();
      late DocumentReference appOnPatientDocument;
      late String id;
      late String date;

      if (result.docs.isNotEmpty) {
        QueryDocumentSnapshot appointmentOnPatient =
            result.docs.firstWhere((element) => element['id'] == appointmentId);
        id = appointmentOnPatient.id;
        date = appointmentOnPatient['date'];

        appOnPatientDocument = _firestore
            .collection('patients')
            .doc(patientId)
            .collection('appointments')
            .doc(id);
      }
      DocumentReference appOnAppointmentCollection = _firestore
          .collection('appointments')
          .doc(date)
          .collection('appointments')
          .doc(appointmentId);
      // ignore: unnecessary_null_comparison
      if (appOnPatientDocument != null) {
        transaction.delete(appOnPatientDocument);
      }

      transaction.delete(appOnAppointmentCollection);
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

  Future<void> startEditingAppointment(
    BuildContext context,
    Appointment appointment,
  ) async {
    // PRZYPISYWANIE AKTUALNYCH DANYCH WIZYTY
    final appointmentHourProv =
        Provider.of<AppointmentHourProvider>(context, listen: false);
    final appointmentDoctorProv =
        Provider.of<AppointmentDoctorProvider>(context, listen: false);
    final appointmentTypeProvider =
        Provider.of<AppointmentTypeProvider>(context, listen: false);
    final doctorDateProv =
        Provider.of<DoctorDataProvider>(context, listen: false);

    appointmentTypeProvider.setEditing(true);
    appointmentTypeProvider.setPrevAppointment(appointment);
    if (doctorDateProv.getAppointmentCategories().isEmpty) {
      await doctorDateProv.loadAppCategories();
    }
    if (doctorDateProv.getDoctors().isEmpty) {
      await doctorDateProv.loadDoctors();
    }

    final AppointmentCategory appointmentCategory = doctorDateProv
        .getAppointmentCategories()
        .firstWhere((element) => element.name == appointment.title);
    final int appTypeIndex =
        doctorDateProv.getAppointmentCategories().indexOf(appointmentCategory);

    if (appointmentTypeProvider.selectedType != appTypeIndex) {
      appointmentTypeProvider.selectAppType(appTypeIndex);
      appointmentTypeProvider.setAppointmentCategoryId(appointmentCategory.id);
    }
    appointmentTypeProvider
        .setPrevNfz(appointment.price != null ? false : true);
    final Duration starthour =
        appointmentHourProv.stringToDuration(appointment.hour);

    final Duration endhour =
        appointmentHourProv.stringToDuration(appointment.hour);

    if (appointmentHourProv.selectedHour != starthour) {
      appointmentHourProv.selctHour(starthour, endhour);
    }

    appointmentHourProv.setDate(appointment.date);
    appointmentHourProv.setIsNFZ(appointment.price != null ? false : true);
    appointmentHourProv.setOldDateForEditing(appointment.date);
    appointmentHourProv.setAppointmentIdForEditing(appointment.id);
    appointmentHourProv.setRefresh(true);

    final Doctor doctor = doctorDateProv
        .getDoctors()
        .firstWhere((element) => element.name == appointment.doctor);
    final int doctorIndex = doctorDateProv
        .getDoctors()
        .where((doctor) => doctor.appointmentTypes
            .where((app) => app.id == appointmentTypeProvider.appointmentTypeId)
            .toList()
            .isNotEmpty)
        .toList()
        .indexOf(doctor);
    if (appointmentDoctorProv.selectedDoctor != doctorIndex) {
      appointmentDoctorProv.selctDoctor(doctorIndex);
      appointmentDoctorProv.setDoctor(doctor);
    }
    AppointmentType appointmentType = doctor.appointmentTypes
        .where((appointmentType) =>
            appointmentType.id == appointmentTypeProvider.appointmentTypeId)
        .first;
    appointmentDoctorProv.setAppointmentType(appointmentType);
    appointmentDoctorProv.setActiveStepIndex(0);
  }

  void clearSettings(BuildContext context) {
    final appointmentHourProv =
        Provider.of<AppointmentHourProvider>(context, listen: false);
    final appointmentDoctorProv =
        Provider.of<AppointmentDoctorProvider>(context, listen: false);
    final appointmentTypeProvider =
        Provider.of<AppointmentTypeProvider>(context, listen: false);

    appointmentHourProv.selctHour(
        const Duration(minutes: 0), const Duration(minutes: 0));
    appointmentHourProv.setDate("");
    appointmentHourProv.setIsNFZ(false);
    appointmentDoctorProv.selctDoctor(-1);
    appointmentDoctorProv.setDoctor(null);
    appointmentDoctorProv.setActiveStepIndex(0);
    appointmentTypeProvider.selectAppType(-1);
    appointmentTypeProvider.setEditing(false);
    appointmentDoctorProv.setAppointmentType(null);
    appointmentTypeProvider.setAppointmentCategoryId('');
  }
}
