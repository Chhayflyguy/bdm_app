import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../baseUrl.dart';
import '../models/booking.dart';
import '../models/employee.dart';

class BookingController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isSuccess = false.obs;
  final RxList<Booking> bookings = <Booking>[].obs;
  final RxBool isLoadingBookings = false.obs;
  final RxList<Employee> employees = <Employee>[].obs;
  final RxBool isLoadingEmployees = false.obs;

  // Change this depending on emulator/device
  // iOS simulator: http://127.0.0.1:8000
  // Android emulator: http://10.0.2.2:8000
  // Physical device: http://YOUR_IP:8000
  String baseUrl = BaseUrl.baseUrl;

  Future<bool> createBooking({
    required String customerName,
    required String customerPhone,
    required int serviceId,
    required String bookingDatetime,
    String? notes,
    List<Map<String, dynamic>>? products,
    int? employeeId,
    String? employeeName,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    isSuccess.value = false;

    try {
      final requestBodyMap = {
        'customer_name': customerName,
        'customer_phone': customerPhone,
        'service_id': serviceId,
        'booking_datetime': bookingDatetime,
        'notes': notes ?? '',
        if (employeeId != null) 'employee_id': employeeId,
        if (employeeName != null) 'employee_name': employeeName,
      };

      // Add products if provided
      if (products != null && products.isNotEmpty) {
        requestBodyMap['products'] = products;
      }

      final requestBody = json.encode(requestBodyMap);

      final response = await http.post(
        Uri.parse('$baseUrl/api/bookings'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: requestBody,
      );

      // Check if response is HTML (error page)
      final contentType = response.headers['content-type'] ?? '';
      if (contentType.contains('text/html') ||
          response.body.trim().startsWith('<!DOCTYPE') ||
          response.body.trim().startsWith('<!doctype')) {
        errorMessage.value =
            'Server returned an error page. Please check the API endpoint. Status: ${response.statusCode}';
        return false;
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        isSuccess.value = true;
        return true;
      } else {
        try {
          final decoded = json.decode(response.body);
          errorMessage.value = decoded['message'] ?? 'Failed to create booking';
        } catch (e) {
          errorMessage.value =
              'Failed to create booking. Status: ${response.statusCode}';
        }
        return false;
      }
    } catch (e) {
      if (e.toString().contains('FormatException') ||
          e.toString().contains('<!DOCTYPE')) {
        errorMessage.value =
            'Server returned an unexpected format. Please check the API endpoint and server configuration.';
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        errorMessage.value =
            'Cannot connect to server. Please check your internet connection and server URL.';
      } else {
        errorMessage.value = 'Error: ${e.toString()}';
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> fetchBookingsByPhone(String phoneNumber) async {
    isLoadingBookings.value = true;
    errorMessage.value = '';
    bookings.clear();

    try {
      final uri = Uri.parse('$baseUrl/api/bookings?phone=$phoneNumber');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      // Check if response is HTML (error page)
      final contentType = response.headers['content-type'] ?? '';
      if (contentType.contains('text/html') ||
          response.body.trim().startsWith('<!DOCTYPE') ||
          response.body.trim().startsWith('<!doctype')) {
        errorMessage.value =
            'Server returned an error page. Please check the API endpoint. Status: ${response.statusCode}';
        return false;
      }

      if (response.statusCode == 200) {
        try {
          final decoded = json.decode(response.body);

          // Handle different response formats
          List<dynamic> bookingsList;
          if (decoded is List) {
            bookingsList = decoded;
          } else if (decoded is Map && decoded.containsKey('data')) {
            bookingsList = decoded['data'];
          } else if (decoded is Map && decoded.containsKey('bookings')) {
            bookingsList = decoded['bookings'] as List;
          } else {
            bookingsList = [];
          }

          bookings.value =
              bookingsList
                  .map((json) => Booking.fromJson(json as Map<String, dynamic>))
                  .toList();

          return true;
        } catch (e) {
          errorMessage.value = 'Failed to parse bookings data: ${e.toString()}';
          return false;
        }
      } else {
        // Try to parse error response as JSON
        try {
          final decoded = json.decode(response.body);
          errorMessage.value =
              decoded['message'] ??
              decoded['error'] ??
              decoded['detail'] ??
              'Failed to fetch bookings: ${response.statusCode}';
        } catch (e) {
          // If response is not JSON, show the status code
          errorMessage.value =
              'Failed to fetch bookings. Server returned status: ${response.statusCode}';
        }
        return false;
      }
    } catch (e) {
      if (e.toString().contains('FormatException') ||
          e.toString().contains('<!DOCTYPE')) {
        errorMessage.value =
            'Server returned an unexpected format. Please check the API endpoint and server configuration.';
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        errorMessage.value =
            'Cannot connect to server. Please check your internet connection and server URL.';
      } else {
        errorMessage.value = 'Error: ${e.toString()}';
      }
      return false;
    } finally {
      isLoadingBookings.value = false;
    }
  }

  Future<bool> updateBooking({
    required int bookingId,
    required String phoneNumber,
    required String bookingDatetime,
    String? notes,
    int? employeeId,
    String? employeeName,
    String? employeePhone,
    String? employeeProfileImageUrl,
    bool updateEmployee = false,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    isSuccess.value = false;

    try {
      final uri = Uri.parse(
        '$baseUrl/api/bookings/$bookingId',
      ).replace(queryParameters: {'phone': phoneNumber});

      final Map<String, dynamic> body = {
        'booking_datetime': bookingDatetime,
        if (notes != null) 'notes': notes,
      };

      if (updateEmployee) {
        body['employee_id'] = employeeId;
        body['employee_name'] = employeeName;
        body['employee_phone'] = employeePhone;
        body['employee_profile_image_url'] = employeeProfileImageUrl;
      }

      final requestBody = json.encode(body);

      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: requestBody,
      );

      // Check if response is HTML (error page)
      final contentType = response.headers['content-type'] ?? '';
      if (contentType.contains('text/html') ||
          response.body.trim().startsWith('<!DOCTYPE') ||
          response.body.trim().startsWith('<!doctype')) {
        errorMessage.value =
            'Server returned an error page. Please check the API endpoint. Status: ${response.statusCode}';
        return false;
      }

      if (response.statusCode == 200) {
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
          errorMessage.value =
              decoded['message'] ??
              decoded['error'] ??
              decoded['detail'] ??
              'Failed to update booking: ${response.statusCode}';
        } catch (e) {
          // If response is not JSON, show the status code
          errorMessage.value =
              'Failed to update booking. Server returned status: ${response.statusCode}';
        }
        return false;
      }
    } catch (e) {
      if (e.toString().contains('FormatException') ||
          e.toString().contains('<!DOCTYPE')) {
        errorMessage.value =
            'Server returned an unexpected format. Please check the API endpoint and server configuration.';
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        errorMessage.value =
            'Cannot connect to server. Please check your internet connection and server URL.';
      } else {
        errorMessage.value = 'Error: ${e.toString()}';
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteBooking({
    required int bookingId,
    required String phoneNumber,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    isSuccess.value = false;

    try {
      final uri = Uri.parse(
        '$baseUrl/api/bookings/$bookingId/',
      ).replace(queryParameters: {'phone': phoneNumber});

      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      // Check if response is HTML (error page)
      final contentType = response.headers['content-type'] ?? '';
      if (contentType.contains('text/html') ||
          response.body.trim().startsWith('<!DOCTYPE') ||
          response.body.trim().startsWith('<!doctype')) {
        errorMessage.value =
            'Server returned an error page. Please check the API endpoint. Status: ${response.statusCode}';
        return false;
      }

      if (response.statusCode == 200 || response.statusCode == 204) {
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
          errorMessage.value =
              decoded['message'] ??
              decoded['error'] ??
              decoded['detail'] ??
              'Failed to delete booking: ${response.statusCode}';
        } catch (e) {
          // If response is not JSON, show the status code
          errorMessage.value =
              'Failed to delete booking. Server returned status: ${response.statusCode}';
        }
        return false;
      }
    } catch (e) {
      if (e.toString().contains('FormatException') ||
          e.toString().contains('<!DOCTYPE')) {
        errorMessage.value =
            'Server returned an unexpected format. Please check the API endpoint and server configuration.';
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        errorMessage.value =
            'Cannot connect to server. Please check your internet connection and server URL.';
      } else {
        errorMessage.value = 'Error: ${e.toString()}';
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> fetchEmployees() async {
    // Skip if already loading
    if (isLoadingEmployees.value) {
      return false;
    }

    // Skip if already loaded and has data
    if (employees.isNotEmpty) {
      return true;
    }

    isLoadingEmployees.value = true;
    errorMessage.value = '';
    employees.clear();

    try {
      final uri = Uri.parse('$baseUrl/api/employees');

      final response = await http
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      // Check if response is HTML (error page)
      final contentType = response.headers['content-type'] ?? '';
      if (contentType.contains('text/html') ||
          response.body.trim().startsWith('<!DOCTYPE') ||
          response.body.trim().startsWith('<!doctype')) {
        errorMessage.value =
            'Server returned an error page. Please check the API endpoint. Status: ${response.statusCode}';
        return false;
      }

      if (response.statusCode == 200) {
        try {
          final decoded = json.decode(response.body);

          // Handle different response formats
          List<dynamic> employeesList;
          if (decoded is List) {
            employeesList = decoded;
          } else if (decoded is Map && decoded.containsKey('data')) {
            employeesList = decoded['data'] as List;
          } else if (decoded is Map && decoded.containsKey('employees')) {
            employeesList = decoded['employees'] as List;
          } else {
            employeesList = [];
          }

          employees.value =
              employeesList
                  .map(
                    (json) => Employee.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();

          return true;
        } catch (e) {
          errorMessage.value =
              'Failed to parse employees data: ${e.toString()}';
          return false;
        }
      } else {
        // Try to parse error response as JSON
        try {
          final decoded = json.decode(response.body);
          errorMessage.value =
              decoded['message'] ??
              decoded['error'] ??
              decoded['detail'] ??
              'Failed to fetch employees: ${response.statusCode}';
        } catch (e) {
          // If response is not JSON, show the status code
          errorMessage.value =
              'Failed to fetch employees. Server returned status: ${response.statusCode}';
        }
        return false;
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        errorMessage.value =
            'Connection timed out. Please check your internet connection.';
      } else if (e.toString().contains('FormatException') ||
          e.toString().contains('<!DOCTYPE')) {
        errorMessage.value =
            'Server returned an unexpected format. Please check the API endpoint and server configuration.';
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        errorMessage.value =
            'Cannot connect to server. Please check your internet connection and server URL.';
      } else {
        errorMessage.value = 'Error: ${e.toString()}';
      }
      return false;
    } finally {
      isLoadingEmployees.value = false;
    }
  }

  Future<bool> refreshEmployees() async {
    employees.clear();
    errorMessage.value = '';
    return await fetchEmployees();
  }
}
