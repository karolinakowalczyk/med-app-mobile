class UserPatient {
  String? id;
  final String name;
  final String email;
  String phone;
  final bool google;

  UserPatient({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.google,
  });

  void setPhoneNumber(String number) {
    phone = number;
  }

  factory UserPatient.fromJSON(String id, dynamic json, bool ifGoogle) {
    return UserPatient(
      id: id,
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      google: ifGoogle,
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
