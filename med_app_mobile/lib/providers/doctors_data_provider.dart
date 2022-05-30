import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:med_app_mobile/models/appointment_type.dart';
import 'package:med_app_mobile/models/doctor_model.dart';

class DoctorDataProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  // ignore: prefer_final_fields
  List<Doctor> _doctors = [];
  // ignore: prefer_final_fields
  List<AppointmentType> _appointmentTypes = [];
  // ignore: prefer_final_fields
  List<AppointmentCategory> _appointmentCategories = [];

  List<Doctor> getDoctors() => _doctors;

  List<AppointmentType> getAppointmentTypes() => _appointmentTypes;
  List<AppointmentCategory> getAppointmentCategories() =>
      _appointmentCategories;

  Future<void> loadAppCategories() async {
    final appointmentsTypesDocs =
        await _firestore.collection('appointmentTypes').get();
    _appointmentCategories.clear();
    for (var appCat in appointmentsTypesDocs.docs) {
      _appointmentCategories.add(
        AppointmentCategory(id: appCat.id, name: appCat['name']),
      );
    }
  }

  Stream<List<AppointmentCategory>> get appointmentCategories => _firestore
          .collection('appointmentTypes')
          .snapshots()
          .asyncMap((appointmentCat) {
        _appointmentCategories.clear();
        for (var appCat in appointmentCat.docs) {
          _appointmentCategories.add(
            AppointmentCategory(id: appCat.id, name: appCat['name']),
          );
        }
        return _appointmentCategories;
      });

  Future<void> loadDoctors() async {
    final doctorsDocs = await _firestore.collection('doctors').get();
    _doctors.clear();
    for (var doct in doctorsDocs.docs) {
      List<AppointmentType> appTypesList = await _firestore
          .collection('doctors')
          .doc(doct.id)
          .collection('appointmentTypes')
          .get()
          .then((appTypesDocs) {
        List<AppointmentType> loadedAppTypesList = [];
        for (var appType in appTypesDocs.docs) {
          loadedAppTypesList.add(
            AppointmentType.fromJson(appType.data()),
          );
        }
        return loadedAppTypesList;
      });
      _doctors.add(
        Doctor.fromJSON(
          doct.id,
          doct.data(),
          appTypesList,
        ),
      );
    }
  }

  Stream<List<Doctor>> get doctors =>
      _firestore.collection('doctors').snapshots().asyncMap((doctors) async {
        _doctors.clear();
        for (var doct in doctors.docs) {
          List<AppointmentType> appTypesList = await _firestore
              .collection('doctors')
              .doc(doct.id)
              .collection('appointmentTypes')
              .get()
              .then((appTypesDocs) {
            List<AppointmentType> loadedAppTypesList = [];
            for (var appType in appTypesDocs.docs) {
              loadedAppTypesList.add(
                AppointmentType.fromJson(appType.data()),
              );
            }
            return loadedAppTypesList;
          });
          _doctors.add(
            Doctor.fromJSON(
              doct.id,
              doct.data(),
              appTypesList,
            ),
          );
        }
        return _doctors;
      });

  // Future<void> loadAppointmentTypes() async {
  //   final appointmentTypesDocs =
  //       await _firestore.collection('appointmentTypes').get();
  //   _appointmentTypes.clear();
  //   for (var appType in appointmentTypesDocs.docs) {
  //     _appointmentTypes.add(
  //       AppointmentType.fromJson(
  //         appType.id,
  //         appType.data(),
  //       ),
  //     );
  //   }
  // }

  Stream<List<AppointmentType>> get appointmentTypes => _firestore
          .collection('appointmentTypes')
          .snapshots()
          .asyncMap((appointmentTypes) {
        _appointmentTypes.clear();
        for (var appType in appointmentTypes.docs) {
          _appointmentTypes.add(
            AppointmentType.fromJson(
              appType.data(),
            ),
          );
        }
        return _appointmentTypes;
      });

  Stream<QuerySnapshot> get doctorsStream =>
      FirebaseFirestore.instance.collection('doctors').snapshots();
}
