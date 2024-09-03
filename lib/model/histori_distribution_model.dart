import 'package:flutter/material.dart';

class HistoriDistribusi {
  final String id;
  final String guid;
  final String guidDistribution;
  final String date;
  final String? image;
  final String description;
  final String createdAt;
  final Coordinates coordinates;

  HistoriDistribusi({
    required this.id,
    required this.guid,
    required this.guidDistribution,
    required this.date,
    required this.image,
    required this.description,
    required this.createdAt,
    required this.coordinates, String? maturityLevel, String? tipeKematangan,
  });

  factory HistoriDistribusi.fromJson(Map<String, dynamic> json) {
    return HistoriDistribusi(
      id: json['_id'],
      guid: json['guid'],
      guidDistribution: json['guidDistribution'],
      date: json['date'],
      image: json['image'],
      description: json['description'],
      createdAt: json['createdAt'],
      coordinates: Coordinates.fromJson(json['coordinates']),
    );
  }

  

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'guid': guid,
      'guidDistribution': guidDistribution,
      'date': date,
      'image': image,
      'description': description,
      'createdAt': createdAt,
      'coordinates': coordinates.toJson(),
    };
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
