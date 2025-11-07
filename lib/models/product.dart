import 'package:flutter/material.dart';

@immutable
class Product {
  final int id;
  final String name;
  final num price;
  final String? description;
  final int quantity;
  final bool inStock;
  final String? imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    required this.quantity,
    required this.inStock,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as num,
      description: json['description'] as String?,
      quantity: json['quantity'] == null ? 0 : (json['quantity'] as num).toInt(),
      inStock: json['in_stock'] == null ? false : (json['in_stock'] as bool),
      imageUrl: json['image'] as String?,
    );
  }
}


