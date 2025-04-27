import '../../config/server_config.dart';
import '../../config/user_info.dart';
import '../../native_service/secure_storage.dart';
import '../../models/mySubscriptions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MySubscriptionsService {
  var url = Uri.parse(ServerConfig.domainNameServer +
      ServerConfig.getMySubscriptions );

  var error;
  final Securestorage _storage = Securestorage();
  late String _token;

  Future<void> getToken() async {
    String? token = await _storage.read("Access Token");
    _token = token!;
    print(_token);
  }

  Future<List<MyCourses>> getAllSubscriptions() async {
    await getToken();
    var response = await http.get(url,
        headers: {"Accept": "application/json", "authorization": _token});

    print(url.toString());
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {

      final mysubscriptionsModel = mysubscriptionsModelFromJson(response.body);
      error = mysubscriptionsModel.msg;
      for (MyCourses c in mysubscriptionsModel.data) print(c.courseTitle);

      return mysubscriptionsModel.data;
    } else {
      return [];
    }
  }
}