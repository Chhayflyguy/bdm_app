import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BookingController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isSuccess = false.obs;

  // Change this depending on emulator/device
  // iOS simulator: http://127.0.0.1:8000
  // Android emulator: http://10.0.2.2:8000
  // Physical device: http://YOUR_IP:8000
  String baseUrl = 'http://127.0.0.1:8000';

  Future<bool> createBooking({
    required String customerName,
    required String customerPhone,
    required int serviceId,
    required String bookingDatetime,
    String? notes,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    isSuccess.value = false;

    try {
      final uri = Uri.parse('$baseUrl/api/bookings');
      final requestBody = json.encode({
        'customer_name': customerName,
        'customer_phone': customerPhone,
        'service_id': serviceId,
        'booking_datetime': bookingDatetime,
        'notes': notes ?? '',
      });
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: requestBody,
      );

      // Check if response is HTML (error page)
      final contentType = response.headers['content-type'] ?? '';
      if (contentType.contains('text/html') || response.body.trim().startsWith('<!DOCTYPE') || response.body.trim().startsWith('<!doctype')) {
        errorMessage.value = 'Server returned an error page. Please check the API endpoint. Status: ${response.statusCode}';
        return false;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Try to parse JSON response (if any)
        try {
          json.decode(response.body);
        } catch (e) {
          // If response is not JSON but status is success, still consider it successful
        }
        isSuccess.value = true;
        return true;
      } else {
        // Try to parse error response as JSON
        try {
          final decoded = json.decode(response.body);
          errorMessage.value = decoded['message'] ?? 
              decoded['error'] ?? 
              decoded['detail'] ??
              'Failed to create booking: ${response.statusCode}';
        } catch (e) {
          // If response is not JSON, show the status code
          errorMessage.value = 'Failed to create booking. Server returned status: ${response.statusCode}';
        }
        return false;
      }
    } catch (e) {
      if (e.toString().contains('FormatException') || e.toString().contains('<!DOCTYPE')) {
        errorMessage.value = 'Server returned an unexpected format. Please check the API endpoint and server configuration.';
      } else if (e.toString().contains('SocketException') || e.toString().contains('Failed host lookup')) {
        errorMessage.value = 'Cannot connect to server. Please check your internet connection and server URL.';
      } else {
        errorMessage.value = 'Error: ${e.toString()}';
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}

