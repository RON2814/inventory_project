import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  //  ↓↓↓↓↓  local ip address change it if its not working. (open cmd and type "ipconfig" and look for IPv4 Address)
  static const localIpAdd = "192.168.254.103";
  static const baseUri =
      "http://$localIpAdd:3000"; // <- this is for LOCAL NODE JS
  // ↓↓↓↓↓ this is for ONLINE NODE JS (render.com) kinna slow ↓↓↓↓↓
  //static const baseUri = "https://ims-nodejs-ron2814.onrender.com";

  Future<List<dynamic>> fetchProduct(int limit, int page) async {
    try {
      final response = await http
          .get(Uri.parse("$baseUri/get-product?_limit=$limit&_page=$page"));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<List<dynamic>> fetchSearchResult(
      String searchQeury, int limit, int page) async {
    try {
      final response = await http.get(Uri.parse(
          "$baseUri/search-product?search=$searchQeury&_limit=$limit&_page=$page"));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<Map<String, dynamic>> fetchOneProduct(String prodId) async {
    try {
      final response = await http.post(Uri.parse("$baseUri/get-one-product"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({"id": prodId}));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fetch data has error: $e');
    }
  }

  Future<List<dynamic>> fetchRecentProduct() async {
    try {
      final response =
          await http.get(Uri.parse("$baseUri/get-product?_limit=4"));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      return [e];
    }
  }

  Future<Map<String, dynamic>> fetchTotalProduct() async {
    try {
      final response = await http.get(Uri.parse("$baseUri/get-total-product"));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<Map<String, dynamic>> addProduct(
    String productName,
    int productPrice,
    int quantity,
    String category,
    String productDesc,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUri/add-product"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'product_name': productName,
          'product_price': productPrice,
          'quantity': quantity,
          'category': category,
          'description': productDesc,
          'date_added': DateTime.now().toString()
        }),
      );
      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": "Product $productName is Successful added.",
          "isInserted": true
        };
      } else {
        return {
          "success": false,
          "message": "Faild to add product.",
          "isInserted": false
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e", "isInserted": false};
    }
  }
}
