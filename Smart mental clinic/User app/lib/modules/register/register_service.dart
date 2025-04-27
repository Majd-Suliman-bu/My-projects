import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pushy_flutter/pushy_flutter.dart';
import 'package:smart_medical_clinic/modules/pushy/pushy.dart';
import '../../config/server_config.dart';
import '../../models/user.dart';

class RegisterService {
  var url = Uri.parse(ServerConfig.domainNameServer + ServerConfig.registerAPI);

  var msg;
  static var error;

  Future<bool> register(User user) async {
    Pushy.setAppId('668fba9225ac2f637cfcdbc5');
    String devicetoken = await pushyRegister();
    print("devicetoken");
    print(devicetoken);
    print("end devicetoken");
    try {
      print("Starting registration");
      Map<String, String> body = {
        'email':
            user.email?.trim() ?? '', // Provide a default empty string if null
        'password': user.password?.trim() ??
            '', // Provide a default empty string if null
        'dateOfBirth': user.dob ?? '', // Provide a default empty string if null
        'gender': user.gender == true ? '1' : '0', // Provide 'Unknown' if null
        'maritalStatus':
            user.maritalstatus ?? '', // Provide a default empty string if null
        'profession':
            user.profession ?? '', // Provide a default empty string if null
        'deviceToken': devicetoken,
      };

      // Conditionally add children if it's not null or empty
      if (user.noc != null && user.noc!.isNotEmpty) {
        body['children'] = user.noc!;
      }
      if (user.hof != null && user.hof!.isNotEmpty) {
        body['hoursOfWork'] = user.hof!;
      }
      if (user.pow != null && user.pow!.isNotEmpty) {
        body['placeOfWork'] = user.pow!;
      }
      print("body");
      print(body);
      print("end body");
      var response = await http.post(
        url,
        headers: {"Accept": "application/json"},
        body: body,
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
