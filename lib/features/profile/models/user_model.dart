class UserModel {
  final int id;
  final String username;
  final String email;
  final String phone;
  final String firstName;
  final String lastName;
  final String city;
  final String street;
  final String zipcode;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.street,
    required this.zipcode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json,)
  {
    final name = json['name'] is Map ? Map<String, dynamic>.from(json['name'] as Map,) : <String, dynamic>{};

    final address = json['address'] is Map ? Map<String, dynamic>.from(json['address'] as Map,) : <String, dynamic>{};

    return UserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      firstName: name['firstname'] as String? ?? '',
      lastName: name['lastname'] as String? ?? '',
      city: address['city'] as String? ?? '',
      street: address['street'] as String? ?? '',
      zipcode: address['zipcode'] as String? ?? '',
    );
  }

  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? username : name;
  }
}