import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:med_app_mobile/models/doctor_model.dart';

class DoctorDataProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  // ignore: prefer_final_fields
  List<Doctor> _doctors = [];

  List<Doctor> getDoctors() => _doctors;

  Stream<List<Doctor>> get doctors =>
      _firestore.collection('doctors').snapshots().asyncMap((doctors) {
        _doctors.clear();
        for (var doct in doctors.docs) {
          _doctors.add(
            Doctor.fromJSON(
              doct.id,
              doct.data(),
            ),
          );
        }
        return _doctors;
      });

  Stream<QuerySnapshot> get doctorsStream =>
      FirebaseFirestore.instance.collection('doctors').snapshots();
}
