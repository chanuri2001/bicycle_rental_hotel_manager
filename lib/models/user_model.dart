class User {
  final String id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? profileImage;
  final String? hotelName;
  final String? district;
  final String? city;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isHotelManager;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.profileImage,
    this.hotelName,
    this.district,
    this.city,
    this.phoneNumber,
    required this.createdAt,
    this.lastLoginAt,
    this.isHotelManager = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      profileImage: json['profileImage'] as String?,
      hotelName: json['hotelName'] as String?,
      district: json['district'] as String?,
      city: json['city'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt:
          json['lastLoginAt'] != null
              ? DateTime.parse(json['lastLoginAt'] as String)
              : null,
      isHotelManager: json['isHotelManager'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'profileImage': profileImage,
      'hotelName': hotelName,
      'district': district,
      'city': city,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'isHotelManager': isHotelManager,
    };
  }

  User copyWith({
    String? firstName,
    String? lastName,
    String? profileImage,
    String? hotelName,
    String? district,
    String? city,
    String? phoneNumber,
  }) {
    return User(
      id: id,
      username: username,
      email: email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileImage: profileImage ?? this.profileImage,
      hotelName: hotelName ?? this.hotelName,
      district: district ?? this.district,
      city: city ?? this.city,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
      isHotelManager: isHotelManager,
    );
  }

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return username;
  }
}
