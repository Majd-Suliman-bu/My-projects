import 'dart:convert';
import '../../config/server_config.dart';
import 'package:http/http.dart' as http;

class OtpService {
  var error;
  var msg;

  Future<bool> sendForgetPasswordOtpVerificationRequest(String otp) async {
    // Construct the URL with query parameters
    var url = Uri.parse(
        ServerConfig.domainNameServer + ServerConfig.forgetPasswordCheckOtpAPI);
    var response = await http.post(url, body: {
      "code": otp,
    });

    print("service");

    print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      msg = jsonResponse['msg'];
      // If successful response
      return true;
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      error = jsonResponse['error'];
      // If response indicates error
      return false;
    } else {
      // Other error scenarios
      return false;
    }
  }
  Future<bool> sendRegisterOtpVerificationRequest(String otp) async {
    // Construct the URL with query parameters
    var url = Uri.parse(
        ServerConfig.domainNameServer + ServerConfig.emailVerificationAPI);
    var response = await http.post(url, body: {
      "code": otp,
    });
    print("service");
    print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      msg = jsonResponse['msg'];
      // If successful response
      return true;
    } else if (response.statusCode == 400 || response.statusCode == 404 || response.statusCode == 500) {
      error = jsonResponse['error'];
      // If response indicates error
      return false;
    } else {
      // Other error scenarios
      return false;
    }
  }
}
