import 'dart:convert';
import '../../config/server_config.dart';
import 'package:http/http.dart' as http;

class ResetPasswordService {
  var url = Uri.parse(
      ServerConfig.domainNameServer + ServerConfig.forgetPasswordAPI);
  var error;
  var msg;

  Future<bool> sendResetPasswordRequest(String email,String otp,String password) async {
    var response = await http.put(url, body: {
      "email": email,
      "new_password":password,
      "code":otp
    });
    print(response.statusCode);
    print(url);
    print ("email:  $email  Otp:  $otp password: $password");
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      msg = jsonResponse['msg'];
      return true;
    } else if (response.statusCode == 400 || response.statusCode == 404 || response.statusCode == 500) {
      error = jsonResponse['error'];
      return false;
    } else {
      return false;
    }
  }
}
