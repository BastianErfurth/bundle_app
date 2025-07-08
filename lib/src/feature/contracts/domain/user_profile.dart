import 'profile.dart';

class UserProfile extends Profile {
  //Attribute
  final String lastName;
  final String firstName;
  bool isPrivate;

  //Konstruktor
  UserProfile({
    required this.lastName,
    required this.firstName,
    required super.street,
    required super.houseNumber,
    required super.zipCode,
    required super.city,
    required this.isPrivate,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'street': street,
      'houseNumber': houseNumber,
      'zipCode': zipCode,
      'city': city,
      'isPrivate': isPrivate,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      street: map['street'] ?? '',
      houseNumber: map['houseNumber'] ?? '',
      zipCode: map['zipCode'] ?? '',
      city: map['city'] ?? '',
      isPrivate: map['isPrivate'] ?? false,
    );
  }

  @override
  String toString() {
    return "$firstName $lastName";
  }

  // Named Constructor für leere Instanz
  UserProfile.empty()
    : lastName = '',
      firstName = '',
      isPrivate = false,
      super(street: '', houseNumber: '', zipCode: '', city: '');

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? street,
    String? houseNumber,
    String? zipCode,
    String? city,
    bool? isPrivate,
  }) {
    return UserProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      street: street ?? this.street,
      houseNumber: houseNumber ?? this.houseNumber,
      zipCode: zipCode ?? this.zipCode,
      city: city ?? this.city,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfile &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.street == street &&
        other.houseNumber == houseNumber &&
        other.zipCode == zipCode &&
        other.city == city &&
        other.isPrivate == isPrivate;
  }

  @override
  int get hashCode => Object.hash(
    firstName,
    lastName,
    street,
    houseNumber,
    zipCode,
    city,
    isPrivate,
  );
}
