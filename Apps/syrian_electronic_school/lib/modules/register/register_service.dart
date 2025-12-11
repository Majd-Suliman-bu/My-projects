import 'dart:convert';

import '../../models/classes.dart';
import '../../models/user.dart';
import '../../config/server_config.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  var url1 =
      Uri.parse(ServerConfig.domainNameServer + ServerConfig.registerAPI);
  var url2 =
      Uri.parse(ServerConfig.domainNameServer + ServerConfig.getAllClasses);
  var msg;
  var error;
  Future<bool> register(User user) async {
    var response = await http.post(
      url1,
      headers: {"Accept": "application/json"},
      body: {
        'first_name': user.firstName,
        'last_name': user.lastName,
        'email': user.email,
        'password': user.password,
        'phone_number': user.phoneNumber,
        'date_of_birth': user.dateOfBirth,
        'interest': user.interest.toString(),
      },
    );
    print(user.firstName);

    print(user.lastName);
    print(user.email);
    print(user.password);
    print(user.dateOfBirth);
    print(user.interest);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      msg = jsonResponse['msg'];
      return true;
    } else if (response.statusCode == 400 ||
        response.statusCode == 409 ||
        response.statusCode == 500) {
      var jsonResponse = jsonDecode(response.body);
      msg = "error";
      error = jsonResponse['error'];
      return false;
    } else {
      return false;
    }
  }

  Future<List<Class>> fetchClasses() async {
    final response = await http.get(url2);

    if (response.statusCode == 200) {
      final classesModel = classesModelFromJson(response.body);
      for (Class c in classesModel.data) {
        print(c.classId);
        print(c.name);
      }
      return classesModel.data;
    } else {
      throw Exception('Failed to load items');
    }
  }
}
