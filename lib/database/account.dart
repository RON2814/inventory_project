import 'dart:convert';
import 'package:again_inventory_project/database/constant.dart';
import 'package:http/http.dart' as http;

class Account {
  static const baseUri = Constant.localBaseUri;

  Future<bool> isServerReady() async {
    try {
      final response = await http.get(Uri.parse(baseUri));
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      throw Exception('Error checking server status: $e');
    }
    return false;
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUri/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: json.encode({'username': username, 'password': password}),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      return {"error": e.toString()};
    }
  }
}
