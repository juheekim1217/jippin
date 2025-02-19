import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

class Address {
  final String name;
  final double latitude;
  final double longitude;
  final String fullName;
  final String? stateCode;
  final String? state;
  final String? city;

  Address({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.fullName,
    this.stateCode,
    this.state,
    this.city,
  });

  // Factory constructor for empty Address
  factory Address.defaultAddress() {
    return Address(
      name: "",
      latitude: 0.0,
      longitude: 0.0,
      fullName: "",
      stateCode: "",
      state: "",
      city: "",
    );
  }

  // Convert Address to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'fullName': fullName,
        'stateCode': stateCode,
        'state': state,
        'city': city,
      };

  // Deserialize JSON back to Address
  factory Address.fromJson(Map<String, dynamic> json) {
    try {
      return Address(
        name: json['name'] ?? "",
        latitude: toDouble(['latitude']) ?? 0.0,
        longitude: toDouble(['longitude']) ?? 0.0,
        fullName: json['fullName'] ?? "",
        stateCode: json['stateCode'] ?? "",
        state: json['state'] ?? "",
        city: json['city'] ?? "",
      );
    } catch (e) {
      return Address.defaultAddress(); // Fallback if parsing fails
    }
  }

  // deserialize City JSON into an Address object
  factory Address.fromMapCity(Map<String, dynamic> map) {
    return Address(
      name: map["n"] ?? "",
      latitude: map["la"] ?? 0.0,
      longitude: map["lo"] ?? 0.0,
      fullName: map["fn"] ?? "",
      //city: city,
      city: map["n"] ?? "",
      state: map["s"] ?? "",
      stateCode: "",
    );
  }

  // deserialize State JSON into an Address object
  factory Address.fromMapState(Map<String, dynamic> map) {
    return Address(
      name: map["n"] ?? "",
      latitude: map["la"] ?? 0.0,
      longitude: map["lo"] ?? 0.0,
      //latitude: double.tryParse(map["latitude"] ?? "0.0") ?? 0.0,
      //longitude: double.tryParse(map["longitude"] ?? "0.0") ?? 0.0,
      fullName: map["n"] ?? "",
      //city: city,
      city: "",
      state: map["n"] ?? "",
      stateCode: map["sc"] ?? "",
    );
  }
}
