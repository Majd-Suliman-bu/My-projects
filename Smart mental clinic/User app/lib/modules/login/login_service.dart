import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:smart_medical_clinic/modules/pushy/pushy.dart';
import '../../config/server_config.dart';
import '../../models/user.dart';

class LoginService {
  var url = Uri.parse(ServerConfig.domainNameServer + ServerConfig.loginAPI);
  FlutterSecureStorage storage =
      FlutterSecureStorage(); // Secure storage instance
  var msg;
  static var error;

  Future<bool> Login(User user) async {
    String devicetoken = await pushyRegister();
    try {
      print("Starting login");
      print(user.email);
      print(user.password);
      print("devicetoken from login: $devicetoken");
      var response = await http.post(
        url,
        headers: {"Accept": "application/json"},
        body: {
          'email': user.email?.trim(),
          'password': user.password?.trim(),
          'deviceToken': devicetoken,
        },
      );
      print(response.body);
      print(response.statusCode);
      print(user.email);
      print(user.password);

      if (response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);
        await storage.write(
            key: 'accessToken', value: jsonResponse['data']['accessToken']);
        await storage.write(
            key: 'refreshToken', value: jsonResponse['data']['refreshToken']);
        await storage.write(
            key: 'Balance', value: jsonResponse['data']['balance'].toString());
        await storage.write(
            key: 'userid', value: jsonResponse['data']['id'].toString());
        await storage.write(
            key: 'username', value: jsonResponse['data']['name'].toString());
        msg = jsonResponse[
            'message']; // Assuming success message is under 'message'
        return true;
      } else {
        var jsonResponse = jsonDecode(response.body);
        error = jsonResponse[
            'message']; // Assuming error message is under 'message'
        print(error);
        return false;
      }
    } catch (e) {
      print('the errer is: $e');
      return false;
    }
  }
}
