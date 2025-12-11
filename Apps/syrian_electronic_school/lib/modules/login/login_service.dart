import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/server_config.dart';
import '../../models/user.dart';
import '../../config/user_info.dart';
import '../../native_service/secure_storage.dart';
import '../../models/loginModel.dart';

class LoginService {
  var url = Uri.parse(ServerConfig.domainNameServer + ServerConfig.loginAPI);
  var error;
  var AccessToken;
  var RefreshToken;
  var name;
  var email;
  var classID;
  var className;

  Future<bool> login(User u) async {
    var response = await http.post(url, body: {
      "email": u.email,
      'password': u.password,
    }, headers: {
      "Accept": "application/json"
    });
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final loginModel = loginModelFromJson(response.body);
      error = loginModel.msg;

      AccessToken = loginModel.data.accessToken;
      RefreshToken = loginModel.data.refreshToken;
      name = loginModel.data.firstName;
      email = u.email;
      classID = loginModel.data.interest.classId;
      className = loginModel.data.interest.name;
      Securestorage storage = Securestorage();
      storage.save("Access Token", AccessToken);
      storage.save("Refresh Token", RefreshToken);
      storage.save("User name", name);
      storage.save("classID", classID.toString());
      storage.save("className", className);
      storage.save("email", email);
      UserInfo.classID = classID;
      UserInfo.className = className;
      UserInfo.user_name = name;
      UserInfo.user_email = email;

      return true;
    } else if (response.statusCode == 401) {
      var jsonResponse = jsonDecode(response.body);
      error = jsonResponse['error'];
      return false;
    } else {
      return false;
    }
  }
}
