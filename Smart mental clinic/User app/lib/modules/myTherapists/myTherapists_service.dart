import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../config/server_config.dart';
import '../../models/therapists.dart';

class MyTherapistsService {
  var message;
  var Therapistsurl =
      Uri.parse(ServerConfig.domainNameServer + ServerConfig.MyTherapists);

  final FlutterSecureStorage _storage = FlutterSecureStorage();
  late String _token;
  late String _userId;
  var deleteTherapisturl1 =
      ServerConfig.domainNameServer + ServerConfig.deleteTherapist1;
  static var error;

  Future<void> getToken() async {
    String? token = await _storage.read(key: "accessToken");
    _token = token!;
    print(_token);
  }

  Future<void> getUserId() async {
    String? userid = await _storage.read(key: "userid");
    _userId = userid!;
    print("User id :::::::: $_userId");
  }

  Future<Therapists?> getTherapists() async {
    try {
      await getToken();
      var response = await http.get(Therapistsurl,
          headers: {"Accept": "application/json", "Authorization": _token});
      print('Therapist status code ${response.statusCode}');
      print('Therapist body :::: ${response.body}');

      if (response.statusCode == 201) {
        return therapistsFromJson(response.body);
      } else {
        print('Failed to load therapists');
        return null;
      }
    } catch (e) {
      print('The error is: $e');
      return null;
    }
  }

  Future<bool?> deleteTherapists(int id) async {
    try {
      await getToken();
      await getUserId();
      var url = Uri.parse(deleteTherapisturl1 +
          id.toString() +
          ServerConfig.deleteTherapist2 +
          _userId +
          ServerConfig.deleteTherapist3);
      print("Delete URL :::::::::::::::: $url");
      var response = await http.delete(url,
          headers: {"Accept": "application/json", "Authorization": _token});
      print('Delete Therapist status code ${response.statusCode}');
      print('Delete Therapist body :::: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        var jsonResponse = jsonDecode(response.body);
        error =
            jsonResponse['error']; // Assuming error message is under 'message'
        return false;
      }
    } catch (e) {
      print('The error is: $e');
      return false;
    }
  }
}
