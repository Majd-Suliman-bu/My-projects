import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../config/server_config.dart';
import '../../models/doctorProfile.dart';

class DoctorProfileService {
  var message;
  //
  var DoctorProfile1url =
      ServerConfig.domainNameServer + ServerConfig.doctorProfile1API;
  var DoctorProfile2url = ServerConfig.doctorProfile2API;
  var requestAppointmenturl =
      ServerConfig.domainNameServer + ServerConfig.requestAppointmentAPI;

  final FlutterSecureStorage _storage = FlutterSecureStorage();
  late String _token;
  static var error;

  Future<void> getToken() async {
    String? token = await _storage.read(key: "accessToken");
    _token = token!;
    print(_token);
  }

  Future<DoctorProfile?> getDoctorProfile() async {
    try {
      // Assuming getToken is now properly implemented and used
      await getToken();
      String? doctorId = await _storage.read(key: "doctorId");
      var url = Uri.parse(DoctorProfile1url + doctorId! + DoctorProfile2url);
      var response = await http.get(url,
          headers: {"Accept": "application/json", "Authorization": _token});
      print(url);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 201) {
        return doctorProfileFromJson(response.body);
      } else {
        print('Failed to load profile');
        return null;
      }
    } catch (e) {
      print('the error is: $e');
      return null;
    }
  }

  Future<bool> RequestAppointment(int id) async {
    // Assuming getToken is now properly implemented and used

    try {
      await getToken();

      var url = Uri.parse(requestAppointmenturl + id.toString());
      var response = await http.post(url,
          headers: {"Accept": "application/json", "Authorization": _token},
          body: {'description': 'dasdasdasda'});

      print(response.statusCode);
      print(response.body);
      print(url);

      if (response.statusCode == 201) {
        return true;
      } else {
        var jsonResponse = jsonDecode(response.body);
        error = jsonResponse[
            'message']; // Assuming error message is under 'message'

        return false;
      }
    } catch (e) {
      print('the error is: $e');
      return false;
    }
  }
}
