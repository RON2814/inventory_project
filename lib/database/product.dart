import 'dart:convert';
import 'package:again_inventory_project/database/constant.dart';
import 'package:http/http.dart' as http;

class Product {
  // * * * Change localBaseUri to deployBaseUri to change from localhost to deployed server
  static const baseUri = Constant.localBaseUri;

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

  /* >>>> RECENT ! ! ! <<<< */
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

  /* >>>> TOTAL PRODUCT ! ! ! <<<< */
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

  /* >>>> UPDATE ! ! ! <<<< */
  Future<Map<String, dynamic>> updateProduct(
    String id,
    String productName,
    int productPrice,
    int newQuantity,
    int oldQuantity,
    String category,
    String productDesc,
    bool isAdded,
    int editedQty,
    String updatedAt,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUri/update-product"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          "id": id,
          "product_name": productName,
          "product_price": productPrice,
          "new_qty": newQuantity,
          "old_qty": oldQuantity,
          "category": category,
          "product_desc": productDesc,
          "is_added": isAdded,
          "edited_qty": editedQty,
          "updated_at": updatedAt,
        }),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to response data');
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e", "isUpdated": false};
    }
  }

  /* >>>> DELETE ! ! ! <<<< */
  Future<Map<String, dynamic>> deleteProduct(String prodId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUri/delete-product"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({"id": prodId}),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to delete product. Status code: ${response.statusCode}, body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Fetch data has error: $e');
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
        Uri.parse("$baseUri/insert-product"),
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

  // * * * HISTORY!!!! * * *
  Future<List<dynamic>> fetchHistory(int limit, int page) async {
    try {
      final response = await http
          .get(Uri.parse("$baseUri/fetch-history?_limit=$limit&_page=$page"));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to load data with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch history: $e');
    }
  }
}
