import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../config/server_config.dart';
import '../../models/userProfile.dart';

class ProfileService {
  var message;
  //
  var UserProfile1url =
      ServerConfig.domainNameServer + ServerConfig.userProfileAPI;
  var redeemCodeUrl = ServerConfig.domainNameServer + ServerConfig.redeemcode;
  FlutterSecureStorage _storage = FlutterSecureStorage();
  late String _token;
  static var error;

  Future<void> getToken() async {
    String? token = await _storage.read(key: "accessToken");
    _token = token!;
    print(_token);
  }

  Future<UserProfile?> getUserProfile() async {
    try {
      // Assuming getToken is now properly implemented and used
      await getToken();

      var url = Uri.parse(UserProfile1url);
      var response = await http.get(url,
          headers: {"Accept": "application/json", "Authorization": _token});
      print(url);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 201) {
        return userProfileFromJson(response.body);
      } else {
        print('Failed to load profile');
        return null;
      }
    } catch (e) {
      print('the error is: $e');
      return null;
    }
  }

  Future<bool> redeemCode(String code) async {
    try {
      await getToken();

      var url = Uri.parse(redeemCodeUrl);
      var response = await http.post(url,
          headers: {"Accept": "application/json", "Authorization": _token},
          body: {"code": code});
      print(url);
      print(response.statusCode);
      print(response.body);

      var responseData = json.decode(response.body);
      if (response.statusCode == 201) {
        await _storage.write(
            key: "Balance", value: responseData['data'].toString());
        return true;
      } else {
        error = responseData['error'];
        return false;
      }
    } catch (e) {
      print('the error is: $e');
      return false;
    }
  }
}
