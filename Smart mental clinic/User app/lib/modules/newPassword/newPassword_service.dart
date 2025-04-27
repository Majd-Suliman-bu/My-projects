import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../config/server_config.dart';

class NewPasswordService {
  var url =
      Uri.parse(ServerConfig.domainNameServer + ServerConfig.forgetPasswordAPI);

  var msg;
  static var error;
  FlutterSecureStorage storage = FlutterSecureStorage();

  Future<bool> SetNewPassword(String password) async {
    try {
      var response = await http.post(
        url,
        headers: {"Accept": "application/json"},
        body: {
          'token': await storage.read(key: 'token'),
          'newPassword': password,
        },
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);
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
      print('the error is: $e');
      return false;
    }
  }
}
