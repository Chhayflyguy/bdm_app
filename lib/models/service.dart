import 'package:flutter/material.dart';

@immutable
class Service {
  final int id;
  final String name;
  final num price;
  final int durationMinutes;
  final String description;
  final String imageUrl;

  const Service({
    required this.id,
    required this.name,
    required this.price,
    required this.durationMinutes,
    required this.description,
    required this.imageUrl,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as num,
      durationMinutes: json['duration_minutes'] as int,
      description: (json['description'] ?? '') as String,
      imageUrl: (json['image_url'] ?? '') as String,
    );
  }
}


