import 'dart:convert';
import '../../config/server_config.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordService {
  var url = Uri.parse(
      ServerConfig.domainNameServer + ServerConfig.forgetPasswordOtpAPI);
  var error;
  var msg;

  Future<bool> sendResetPasswordRequest(String email) async {
    var response = await http.post(url, body: {
      "email": email,
    });
    print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      msg = jsonResponse['msg'];
      return true;
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      error = jsonResponse['error'];
      return false;
    } else {
      return false;
    }
  }
}
