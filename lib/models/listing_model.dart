import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  final String id;
  final String name;
  final String category;
  final String address;
  final String contact;
  final String description;
  final double latitude;
  final double longitude;
  final String createdBy;
  final DateTime timestamp;
  final double rating;

  Listing({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.contact,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.timestamp,
    this.rating = 0.0,
  });

  factory Listing.fromFirestore(Map<String, dynamic> data, String id) {
    return Listing(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      address: data['address'] ?? '',
      contact: data['contact'] ?? '',
      description: data['description'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      createdBy: data['createdBy'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      rating: (data['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "category": category,
      "address": address,
      "contact": contact,
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
      "createdBy": createdBy,
      "timestamp": Timestamp.fromDate(timestamp),
      "rating": rating,
    };
  }

  /// COPY WITH
  Listing copyWith({
    String? id,
    String? name,
    String? category,
    String? address,
    String? contact,
    String? description,
    double? latitude,
    double? longitude,
    String? createdBy,
    DateTime? timestamp,
    double? rating,
  }) {
    return Listing(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdBy: createdBy ?? this.createdBy,
      timestamp: timestamp ?? this.timestamp,
      rating: rating ?? this.rating,
    );
  }
}