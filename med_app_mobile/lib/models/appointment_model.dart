class Appointment {
  String id;
  final String title;
  final String doctor;
  final String hour;
  final String date;

  Appointment({
    required this.id,
    required this.title,
    required this.doctor,
    required this.hour,
    required this.date,
  });

  factory Appointment.fromJSON(String id, dynamic json) {
    return Appointment(
      id: id,
      title: json['title'],
      doctor: json['doctorName'],
      hour: json['hour'],
      date: json['date'],
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
