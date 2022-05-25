import 'package:med_app_mobile/models/appointment_type.dart';

class Doctor {
  final String id;
  final String name;
  final String email;
  final String phone;
  final List<AppointmentType> appointmentTypes;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.appointmentTypes,
  });

  factory Doctor.fromJSON(
    String id,
    dynamic json,
    List<AppointmentType> appList,
  ) {
    return Doctor(
      id: id,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      appointmentTypes: appList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
