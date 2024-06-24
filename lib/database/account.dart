import 'dart:convert';
import 'package:http/http.dart' as http;

class Account {
  //  ↓↓↓↓↓  local ip address change it if its not working. (open cmd and type "ipconfig" and look for IPv4 Address)
  static const localIpAdd = "192.168.1.121";
  //static const baseUri = "http://$localIpAdd:3000"; // <- this is for LOCAL NODE JS
  // ↓↓↓↓↓ this is for ONLINE NODE JS (render.com) kinna slow ↓↓↓↓↓
  static const baseUri = "https://ims-nodejs-ron2814.onrender.com";

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
