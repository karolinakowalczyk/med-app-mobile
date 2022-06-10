import 'package:validators/validators.dart';

class AppointmentCategory {
  final String id;
  final String name;

  AppointmentCategory({
    required this.id,
    required this.name,
  });
}

class AppointmentType {
  final String id;
  final String name;
  final int estimatedTime;
  final double cost;

  AppointmentType({
    required this.id,
    required this.name,
    required this.estimatedTime,
    required this.cost,
  });

  factory AppointmentType.fromJson(String id, dynamic json) {
    final AppointmentType app = AppointmentType(
      id: json['id'] ?? id,
      name: json['name'] ?? '',
      estimatedTime: json['estimatedTime'].runtimeType == int
          ? json['estimatedTime']
          : isNumeric(json['estimatedTime'].toString())
              ? int.parse(json['estimatedTime'].toString())
              : 15,
      cost: isNumeric(json['price'].toString())
          ? double.parse(json['price'].toString())
          : 0,
    );
    return app;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'estimatedTime': estimatedTime,
      'cost': cost,
    };
  }
}
