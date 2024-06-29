class Constant {
  //  ↓↓↓↓↓  local ip address change it if its not working. (open cmd and type "ipconfig" and look for IPv4 Address)
  static const String localIpAdd = "192.168.1.121";

  // ↓↓↓↓↓ this is for LOCAL NODE JS
  static const String localBaseUri = "http://$localIpAdd:3000";

  // ↓↓↓↓↓ this is for ONLINE NODE JS (render.com) kinna slow ↓↓↓↓↓
  static const String deployBaseUri = "https://ims-nodejs-ron2814.onrender.com";
}
