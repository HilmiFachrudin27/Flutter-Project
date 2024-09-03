import 'dart:convert';

class Survey {
  final String id;
  final String guid;
  final String guidCompany;
  final String date;
  final String description;
  final String image;
  final String createdAt;
  final Coordinates coordinates;

  Survey({
    required this.id,
    required this.guid,
    required this.guidCompany,
    required this.date,
    required this.description,
    required this.image,
    required this.createdAt,
    required this.coordinates,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      id: json['_id'],
      guid: json['guid'],
      guidCompany: json['guidCompany'],
      date: json['date'],
      description: json['description'],
      image: json['image'],
      createdAt: json['createAt'],
      coordinates: Coordinates.fromJson(json['coordinates']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'guid': guid,
      'guidCompany': guidCompany,
      'date': date,
      'description': description,
      'image': image,
      'createAt': createdAt,
      'coordinates': coordinates.toJson(),
    };
  }

  Survey copyWith({
    String? id,
    String? guid,
    String? guidCompany,
    String? date,
    String? description,
    String? image,
    String? createdAt,
    Coordinates? coordinates,
  }) {
    return Survey(
      id: id ?? this.id,
      guid: guid ?? this.guid,
      guidCompany: guidCompany ?? this.guidCompany,
      date: date ?? this.date,
      description: description ?? this.description,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      coordinates: coordinates ?? this.coordinates,
    );
  }
}

class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates({
    required this.latitude,
    required this.longitude,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
