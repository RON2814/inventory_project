import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  static const baseUri = "http://localhost:3000/api";

  Future<List<dynamic>> fetchProduct() async {
    final response = await http.get(Uri.parse("$baseUri/get_product"));
    try {
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      return [e];
    }
  }

  Future<Map<String, dynamic>> addProduct(
    String productName,
    int quantity,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUri/add_product"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({'product_name': productName, 'quantity': quantity}),
      );
      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": "Product $productName is Successful added."
        };
      } else {
        return {"success": false, "message": "Faild to add product."};
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }
}
