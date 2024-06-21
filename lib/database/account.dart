import 'dart:convert';
import 'package:http/http.dart' as http;

class Account {
  static const baseUri = "https://ims-nodejs-ron2814.onrender.com";
  // static const localIpAdd = "192.168.1.10";
  // static const baseUri = "http://$localIpAdd:3000";

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
