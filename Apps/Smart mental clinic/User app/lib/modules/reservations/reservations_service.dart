import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:smart_medical_clinic/models/appointments.dart';
import 'package:smart_medical_clinic/models/appoints.dart';
import 'package:http/http.dart' as http;
import '../../config/server_config.dart';

class ReservationsService {
  var message;
  //
  var Allreservations = Uri.parse(
      ServerConfig.domainNameServer + ServerConfig.appointmentHomeAPI);
  //
  var RemoveReservation = Uri.parse(
      ServerConfig.domainNameServer + ServerConfig.appointmentRemoveAPI);
  //
  var CancelReservation = Uri.parse(
      ServerConfig.domainNameServer + ServerConfig.appointmentCancelAPI);
  //
  var AcceptReservation1 = Uri.parse(
      ServerConfig.domainNameServer + ServerConfig.appointmentAccept1API);

  //
  var AcceptReservation2 = Uri.parse(ServerConfig.appointmentAccept2API);
  //
  var ShowAppointment = Uri.parse(
      ServerConfig.domainNameServer + ServerConfig.showAppointmentAPI);
  //
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  late String _token;
  static var error;

  Future<void> getToken() async {
    String? token = await _storage.read(key: "accessToken");
    _token = token!;
    print(_token);
  }

  Future<List<Datum>> GetAppointments() async {
    try {
      await getToken();
      var response = await http.get(Allreservations,
          headers: {"Accept": "application/json", "Authorization": _token});
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        var appointmentResponse = appointmentsResponseFromJson(response.body);
        return appointmentResponse.data;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('the error is: $e');
      return [];
    }
  }

  Future<bool> RemoveAppointment(int id) async {
    try {
      await getToken();
      var deleteUrl = Uri.parse('${RemoveReservation.toString()}$id');
      var response = await http.delete(deleteUrl,
          headers: {"Accept": "application/json", "Authorization": _token});

      print(response.statusCode);
      if (response.statusCode == 200) {
        return true;
      } else {
        // Parse the error message from the response body
        var responseJson = json.decode(response.body);
        error = responseJson['message'];
        return false;
      }
    } catch (e) {
      print('the error is: $e');
      return false;
    }
  }

  Future<bool> CancelAppointment(int id) async {
    try {
      await getToken();
      var cancelUrl = Uri.parse('${CancelReservation.toString()}$id');
      var response = await http.post(
        cancelUrl,
        headers: {"Accept": "application/json", "Authorization": _token},
        body: {'description': 'sssssssssss'},
      );
      print(response.body);
      print(response.statusCode);
      print(cancelUrl);
      if (response.statusCode == 201) {
        return true;
      } else {
        print(response.body);
        var jsonResponse = jsonDecode(response.body);
        error = jsonResponse[
            'message']; // Assuming error message is under 'message'
        print(error);
        throw Exception(error); // Throw an exception with the error message
      }
    } catch (e) {
      print('the error is: $e');
      return false;
    }
  }

  Future<bool> AcceptAppointment(int id) async {
    try {
      await getToken();
      var Accept1lUrl = Uri.parse('${AcceptReservation1.toString()}$id');
      var Accept2lUrl =
          Uri.parse(Accept1lUrl.toString() + AcceptReservation2.toString());
      var response = await http.get(
        Accept2lUrl,
        headers: {"Accept": "application/json", "Authorization": _token},
      );
      print(response.statusCode);
      print(Accept2lUrl);
      if (response.statusCode == 200) {
        return true;
      } else {
        var jsonResponse = jsonDecode(response.body);
        error = jsonResponse[
            'message']; // Assuming error message is under 'message'
        print(error);
        throw Exception(error); // Throw an exception with the error message
      }
    } catch (e) {
      print('the error is: $e');
      return false;
    }
  }

  Future<bool> ShowAppointmentStatus(int id) async {
    try {
      await getToken();
      var ShowAppointmentUrl = Uri.parse('${ShowAppointment.toString()}$id');
      var response = await http.get(
        ShowAppointmentUrl,
        headers: {"Accept": "application/json", "Authorization": _token},
      );
      print(response.statusCode);
      print(ShowAppointmentUrl);

      var jsonResponse = jsonDecode(response.body); // Define jsonResponse here
      print(jsonResponse);

      if (response.statusCode == 201) {
        // Ensure the status code is 200 for a successful response
        if (jsonResponse['success'] == true) {
          var appointments = jsonResponse['data'];
          if (appointments.isNotEmpty) {
            // Assuming the structure always contains at least one appointment in the data array
            var firstAppointment = appointments[0]['appointments'];
            bool isReady = firstAppointment['isReady'];

            return isReady; // Return true only if isReady is true
          }
        }
        return false; // Return false if no data or success is not true
      } else {
        error = jsonResponse['message'];
        return false;
      }
    } catch (e) {
      print('the error is: $e');
      return false;
    }
  }
}
