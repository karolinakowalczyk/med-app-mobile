class Doctor {
  final String id;
  final String name;
  final String email;
  final String phone;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory Doctor.fromJSON(String id, dynamic json) {
    return Doctor(
      id: id,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
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
