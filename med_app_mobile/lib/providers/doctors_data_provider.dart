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

  Stream<List<AppointmentCategory>> get appointmentCategories =>
      FirebaseFirestore.instance
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
