class Appointment {
  String id;
  final String title;
  final String doctor;
  final String hour;
  final String endHour;
  final String date;
  final double? price;

  Appointment({
    required this.id,
    required this.title,
    required this.doctor,
    required this.hour,
    required this.endHour,
    required this.date,
    required this.price,
  });

  factory Appointment.fromJSON(String id, dynamic json) {
    return Appointment(
      id: id,
      title: json['title'],
      doctor: json['doctorName'],
      hour: json['hour'],
      endHour: json['endHour'],
      date: json['date'],
      price:
          json['price'] != null ? double.parse(json['price'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'doctor': doctor,
      'hour': hour,
      'date': date,
    };
  }
}
