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

  factory AppointmentType.fromJson(dynamic json) {
    final AppointmentType app = AppointmentType(
      id: json['id'],
      name: json['name'],
      estimatedTime: json['estimatedTime'].runtimeType == int
          ? json['estimatedTime']
          : int.parse(json['estimatedTime'].toString()),
      cost: double.parse(json['price'].toString()),
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
