class UserPatient {
  String? id;
  final String name;
  final String email;
  final String phone;

  UserPatient({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory UserPatient.fromJSON(String id, dynamic json) {
    return UserPatient(
      id: id,
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  @override
  String toString() {
    return '{ id: $id, name: $name, email: $email, phone: $phone }';
  }
}
