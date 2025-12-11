import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/server_config.dart';

class ForgotPasswordService {
  static var error; // Ensure this is static if you want to access it directly without an instance

  Future<bool> ResendOTP(String email) async {
    try {
      var url =
          Uri.parse(ServerConfig.domainNameServer + ServerConfig.resendOtpAPI);
      var response = await http.post(
        url,
        headers: {"Accept": "application/json"},
        body: {'email': email},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        var jsonResponse = jsonDecode(response.body);
        error = jsonResponse[
            'message']; // Capture the error message from the response
        return false;
      }
    } catch (e) {
      print('the error is: $e');
      return false;
    }
  }

  Future<int> checkEmail(String email) async {
    try {
      var url =
          Uri.parse(ServerConfig.domainNameServer + ServerConfig.checkEmailAPI);
      var response = await http.post(
        url,
        headers: {"Accept": "application/json"},
        body: {'email': email},
      );

      if (response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);
        bool data = jsonResponse['data'];
        if (data == true) {
          return 0;
        } else {
          return 1;
        }
      } else {
        return 2;
      }
    } catch (e) {
      print('the error is: $e');
      return 3;
    }
  }
}
