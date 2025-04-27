import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import '../../config/server_config.dart';
import '../../models/doctorsList.dart';

class DoctorService {
  var message;
  //
  var Doctorsurl =
      Uri.parse(ServerConfig.domainNameServer + ServerConfig.doctorListAPI);

  final FlutterSecureStorage _storage = FlutterSecureStorage();
  late String _token;

  Future<void> getToken() async {
    String? token = await _storage.read(key: "accessToken");
    _token = token!;
    print(_token);
  }

  Future<DoctorsList?> getDoctors() async {
    try {
      // Assuming getToken is now properly implemented and used
      await getToken();
      var response = await http.get(Doctorsurl,
          headers: {"Accept": "application/json", "Authorization": _token});

      if (response.statusCode == 201) {
        // Assuming 200 is the success status code
        return doctorsListFromJson(response.body);
      } else {
        print('Failed to load doctors');
        return null;
      }
    } catch (e) {
      print('the error is: $e');
      return null;
    }
  }
}
