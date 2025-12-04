import 'package:flutter/material.dart';

@immutable
class Booking {
  final int id;
  final String customerName;
  final String customerPhone;
  final int serviceId;
  final String? serviceName;
  final int? employeeId;
  final String? employeeName;
  final String? employeePhone;
  final String? employeeProfileImageUrl;
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
    this.employeeId,
    this.employeeName,
    this.employeePhone,
    this.employeeProfileImageUrl,
    required this.bookingDatetime,
    this.notes,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    // Handle employee data - check if it's nested or flat
    int? employeeId;
    String? employeeName;
    String? employeePhone;
    String? employeeProfileImageUrl;

    if (json['employee'] != null && json['employee'] is Map) {
      // New nested structure
      final employee = json['employee'] as Map<String, dynamic>;
      employeeId = (employee['id'] as num?)?.toInt();
      employeeName = employee['name'] as String?;
      employeePhone = employee['phone'] as String?;
      employeeProfileImageUrl = employee['profile_image_url'] as String?;
    } else {
      // Old flat structure (for backward compatibility)
      employeeId = (json['employee_id'] as num?)?.toInt();
      employeeName = json['employee_name'] as String?;
      employeePhone = json['employee_phone'] as String?;
      employeeProfileImageUrl = json['employee_profile_image_url'] as String?;
    }

    return Booking(
      id: (json['id'] as num?)?.toInt() ?? 0,
      customerName: json['customer_name'] as String? ?? '',
      customerPhone: json['customer_phone'] as String? ?? '',
      serviceId: (json['service_id'] as num?)?.toInt() ?? 0,
      serviceName: json['service_name'] as String?,
      employeeId: employeeId,
      employeeName: employeeName,
      employeePhone: employeePhone,
      employeeProfileImageUrl: employeeProfileImageUrl,
      bookingDatetime: json['booking_datetime'] as String? ?? '',
      notes: json['notes'] as String?,
      status: json['status'] as String?,
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'] as String)
              : null,
      updatedAt:
          json['updated_at'] != null
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
