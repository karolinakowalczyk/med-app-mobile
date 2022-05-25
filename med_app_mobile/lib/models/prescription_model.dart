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

    for (var med in json['medicines'] as List) {
      medicines.add(Medicine(
          name: med['medicine'] ?? '',
          description: med['recommendations'] ?? ''));
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
