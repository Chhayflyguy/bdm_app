import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/service.dart';
import '../baseUrl.dart';

class ServicesController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<Service> services = <Service>[].obs;

  // Change this depending on emulator/device
  // iOS simulator: http://127.0.0.1:8000
  // Android emulator: http://10.0.2.2:8000
  // Physical device: http://YOUR_IP:8000
  String baseUrl = BaseUrl.baseUrl;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final uri = Uri.parse('$baseUrl/api/services');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);

        List<dynamic> list;
        if (decoded is List) {
          list = decoded;
        } else if (decoded is Map<String, dynamic>) {
          if (decoded['data'] is List) {
            list = decoded['data'] as List<dynamic>;
          } else if (decoded['services'] is List) {
            list = decoded['services'] as List<dynamic>;
          } else {
            throw 'Unexpected response shape: expected List or {data:[...]}/{services:[...]}';
          }
        } else {
          throw 'Unexpected response type: ${decoded.runtimeType}';
        }

        services.value = list
            .map((e) => Service.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        errorMessage.value = 'Failed to load services: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}


