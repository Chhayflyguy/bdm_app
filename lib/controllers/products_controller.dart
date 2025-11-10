import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../baseUrl.dart';

class ProductsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<Product> products = <Product>[].obs;

  String baseUrl = BaseUrl.baseUrl;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final uri = Uri.parse('$baseUrl/api/products');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);

        List<dynamic> list;
        if (decoded is List) {
          list = decoded;
        } else if (decoded is Map<String, dynamic>) {
          if (decoded['data'] is List) {
            list = decoded['data'] as List<dynamic>;
          } else if (decoded['products'] is List) {
            list = decoded['products'] as List<dynamic>;
          } else {
            throw 'Unexpected response shape: expected List or {data:[...]}/{products:[...]}';
          }
        } else {
          throw 'Unexpected response type: ${decoded.runtimeType}';
        }

        products.value = list
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        errorMessage.value = 'Failed to load products: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}


