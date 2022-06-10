import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Medicine {
  final String name;
  final String description;

  Medicine({
    required this.name,
    required this.description,
  });
}

class Prescription {
  final String id;
  final List<Medicine> medicines;
  final String doctor;
  final DateTime date;
  final String accessCode;
  final bool done;

  Prescription({
    required this.id,
    required this.medicines,
    required this.doctor,
    required this.accessCode,
    required this.date,
    required this.done,
  });

  factory Prescription.fromJSON(String id, dynamic json, String doctor) {
    List<Medicine> medicines = [];
    String name;
    String desc;

    for (var med in json['medicines'] as List) {
      if (med['medicine'] == null) {
        if (med['name'] == null) {
          name = "";
        } else {
          name = med['name'];
        }
      } else {
        name = med['medicine'];
      }
      if (med['recommendations'] == null) {
        if (med['description'] == null) {
          desc = "";
        } else {
          desc = med['description'];
        }
      } else {
        desc = med['recommendations'];
      }

      medicines.add(
        Medicine(name: name, description: desc),
      );
    }
    DateTime dat = DateFormat('dd-MM-yyy').parse(json['date']);
    return Prescription(
      id: id,
      medicines: medicines,
      doctor: doctor,
      accessCode: json['number'] ?? '1234',
      date: dat,
      done: json['done'],
    );
  }
}
