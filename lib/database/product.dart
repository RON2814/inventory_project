import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  static const localIpAdd = "192.168.1.10";
  //static const baseUri = "http://$localIpAdd:3000";
  static const baseUri = "https://ims-nodejs-ron2814.onrender.com";

  Future<List<dynamic>> fetchProduct() async {
    try {
      final response = await http.get(Uri.parse("$baseUri/get_product"));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      return [e];
    }
  }

  Future<List<dynamic>> fetchRecentProduct() async {
    try {
      final response =
          await http.get(Uri.parse("$baseUri/get_product?_limit=4"));

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
    int productPrice,
    int quantity,
    String category,
    String expDate,
    String productDesc,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUri/add_product"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'product_name': productName,
          'product_price': productPrice,
          'quantity': quantity,
          'category': category,
          'expiration_date': expDate,
          'description': productDesc
        }),
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
