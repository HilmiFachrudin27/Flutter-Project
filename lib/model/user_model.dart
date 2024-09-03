import 'dart:convert';

class UserModel {
  final String code;
  final String guid;
  final String name;
  final String email;
  final String createdAt;
  final List<Application> applications;
  final String phoneNumber;
  final String address;
  final String imageProfile;
  

  UserModel({
    required this.code,
    required this.guid,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.applications,
    required this.phoneNumber,
    required this.address,
    required this.imageProfile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      code: json['code'] ?? '',
      guid: json['guid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      createdAt: json['createdAt'] ?? '',
      applications: (json['applications'] as List<dynamic>?)
              ?.map((item) => Application.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      imageProfile: json['imageProfile'] ?? '',
    );
  }
}

class Application {
  final String name;
  final String companyGuid;
  final String guidAplication;
  final String role;
  final String key;
  final bool isActive;
  final String otp;
  final String id;

  Application({
    required this.name,
    required this.companyGuid,
    required this.guidAplication,
    required this.role,
    required this.key,
    required this.isActive,
    required this.otp,
    required this.id,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      name: json['name'] ?? '',
      companyGuid: json['companyGuid'] ?? '',
      guidAplication: json['guidAplication'] ?? '',
      role: json['role'] ?? '',
      key: json['key'] ?? '',
      isActive: json['isActive'] ?? false,
      otp: json['otp'] ?? '',
      id: json['_id'] ?? '',
    );
  }
}
