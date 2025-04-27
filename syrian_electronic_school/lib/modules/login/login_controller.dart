import 'package:get/get.dart';

import '../../models/user.dart';
import './login_service.dart';

class LoginController extends GetxController {
  var email;
  var password;
  var loginStatus;
  var error;
  var token;
  late LoginService service;

  @override
  void onInit() {
    email = "";
    password = "";
    loginStatus = false;
    error = "";
    token = "";
    service = LoginService();
    super.onInit();
  }

  Future<void> LoginOnclick() async {
    User u = User(email: email, password: password);
    loginStatus = await service.login(u);
    error = service.error;
  }
}
