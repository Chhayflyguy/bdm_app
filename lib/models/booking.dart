import 'package:flutter/material.dart';

@immutable
class Booking {
  final int id;
  final String customerName;
  final String customerPhone;
  final int serviceId;
  final String? serviceName;
  final String bookingDatetime;
  final String? notes;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Booking({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.serviceId,
    this.serviceName,
    required this.bookingDatetime,
    this.notes,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: (json['id'] as num?)?.toInt() ?? 0,
      customerName: json['customer_name'] as String? ?? '',
      customerPhone: json['customer_phone'] as String? ?? '',
      serviceId: (json['service_id'] as num?)?.toInt() ?? 0,
      serviceName: json['service_name'] as String?,
      bookingDatetime: json['booking_datetime'] as String? ?? '',
      notes: json['notes'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  DateTime get bookingDate {
    try {
      return DateTime.parse(bookingDatetime);
    } catch (e) {
      return DateTime.now();
    }
  }
}

