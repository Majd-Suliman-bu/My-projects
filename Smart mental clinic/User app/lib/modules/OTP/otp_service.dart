import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/server_config.dart';

class OTPService {
  static var error; // Ensure this is static if you want to access it directly without an instance

  Future<bool> verifyOTP(String otp) async {
    try {
      var url = Uri.parse(
          ServerConfig.domainNameServer + ServerConfig.emailVerificationAPI);
      var response = await http.post(
        url,
        headers: {"Accept": "application/json"},
        body: {"token": otp},
      );

      if (response.statusCode == 200) {
        // Assuming 200 is the success status code
        return true;
      } else {
        var jsonResponse = jsonDecode(response.body);
        error = jsonResponse[
            'message']; // Make sure this is correctly capturing the error message
        return false;
      }
    } catch (e) {
      print('the error is: $e');
      return false;
    }
  }

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

  Future<bool> VerifyToken(String otp) async {
    try {
      var url = Uri.parse(
          ServerConfig.domainNameServer + ServerConfig.forgetPasswordToken);
      var response = await http.post(
        url,
        headers: {"Accept": "application/json"},
        body: {"token": otp},
      );

      if (response.statusCode == 200) {
        print(
            "ITS TRUEE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
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
}
