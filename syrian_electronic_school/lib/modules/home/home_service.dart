import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/user_info.dart';
import '../../config/server_config.dart';
import '../../models/courses_model.dart';
import '../../models/classes.dart';
import '../../native_service/secure_storage.dart';

class Homeservice {
  var url = Uri.parse(ServerConfig.domainNameServer +
      ServerConfig.getAllSubjectsForLevel +
      UserInfo.classID.toString());

  var error;
  final Securestorage _storage = Securestorage();
  late String _token;

  Future<void> getToken() async {
    String? token = await _storage.read("Access Token");
    _token = token!;
    print(_token);
  }

  Future<List<course>> getAllSubjectsForLevel() async {
    await getToken();
    var response = await http.get(url,
        headers: {"Accept": "application/json", "authorization": _token});

    print(url.toString());
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final coursesModel = coursesModelFromJson(response.body);
      error = coursesModel.message;
      for (course c in coursesModel.data) print(c.title);

      return coursesModel.data;
    } else {
      return [];
    }
  }

  Future<List<Class>> fetchClasses() async {
    var url =
        Uri.parse(ServerConfig.domainNameServer + ServerConfig.getAllClasses);
    final response = await http.get(url);

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
