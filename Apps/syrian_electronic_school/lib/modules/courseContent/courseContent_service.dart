import 'dart:convert';

import 'package:get/get.dart';
import 'package:syrian_electronic_school/config/server_config.dart';
import 'package:http/http.dart' as http;
import 'package:syrian_electronic_school/config/user_info.dart';
import 'package:syrian_electronic_school/native_service/secure_storage.dart';

import '../../models/Course.dart';

class CourseContentService {

  var message;
  var url =
      Uri.parse(ServerConfig.domainNameServer + ServerConfig.showCourse + UserInfo.courseId.toString());
  final Securestorage _storage = Securestorage();
  late String _token ;

  Future<void> getToken() async {
    String? token = await _storage.read("Access Token");
    _token = token!;
    print(_token);
  }

  Future<Data> showCourse() async {
    await getToken();
    var response = await http.get(url,
        headers: {"Accept": "application/json", "authorization": _token});
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var course = courseFromJson(response.body);
      return course.data; // Return only the data part of the response
    } else {
      throw Exception('Failed to load course data');
    }
  }
}
