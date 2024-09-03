import 'dart:convert';

class Distribution {
  final String id;
  final String guid;
  final String guidCompany;
  final String vehiclePlate;
  final DateTime date; // This should be DateTime
  final String officerName;
  final String guidOfficer;
  final int boxQty;
  final DateTime createdAt; // This should be DateTime

  Distribution({
    required this.id,
    required this.guid,
    required this.guidCompany,
    required this.vehiclePlate,
    required this.date,
    required this.officerName,
    required this.guidOfficer,
    required this.boxQty,
    required this.createdAt,
  });

  factory Distribution.fromJson(Map<String, dynamic> json) {
    return Distribution(
      id: json['_id'] as String,
      guid: json['guid'] as String,
      guidCompany: json['guidCompany'] as String,
      vehiclePlate: json['vehiclePlate'] as String,
      date: DateTime.parse(json['date'] as String), // Convert String to DateTime
      officerName: json['officerName'] as String,
      guidOfficer: json['guidOfficer'] as String,
      boxQty: json['boxQty'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String), // Convert String to DateTime
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'guid': guid,
      'guidCompany': guidCompany,
      'vehiclePlate': vehiclePlate,
      'date': date.toIso8601String(), // Convert DateTime to String
      'officerName': officerName,
      'guidOfficer': guidOfficer,
      'boxQty': boxQty,
      'createdAt': createdAt.toIso8601String(), // Convert DateTime to String
    };
  }

  Distribution copyWith({
    String? id,
    String? guid,
    String? guidCompany,
    String? vehiclePlate,
    DateTime? date, // Update to DateTime
    String? officerName,
    String? guidOfficer,
    int? boxQty,
    DateTime? createdAt, // Update to DateTime
  }) {
    return Distribution(
      id: id ?? this.id,
      guid: guid ?? this.guid,
      guidCompany: guidCompany ?? this.guidCompany,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      date: date ?? this.date, // Update to DateTime
      officerName: officerName ?? this.officerName,
      guidOfficer: guidOfficer ?? this.guidOfficer,
      boxQty: boxQty ?? this.boxQty,
      createdAt: createdAt ?? this.createdAt, // Update to DateTime
    );
  }
}
