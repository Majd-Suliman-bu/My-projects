import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:smart_medical_clinic/models/chatResponse.dart';
import '../../config/server_config.dart';

class ChatbotService {
  var url =
      Uri.parse(ServerConfig.chatbotServer + ServerConfig.getChatBotQuestions);
  FlutterSecureStorage s = FlutterSecureStorage();
  var botscoreurl =
      Uri.parse(ServerConfig.domainNameServer + ServerConfig.botscore);
  late String _token;
  FlutterSecureStorage _storage = FlutterSecureStorage();

  var msg;
  static var error;

  Future<void> getToken() async {
    String? token = await _storage.read(key: "accessToken");
    _token = token!;
    print(_token);
  }

  Future<List<ChatResponse>?> getQuestion(String msg) async {
    try {
      print("Starting getQuestion");

      print(msg);
      print(url);

      var response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"sender": "test_user", "message": msg}),
      );

      print("response.statusCode: ${response.statusCode}");

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as List<dynamic>;
        print(jsonResponse);

        // Check for "total score" in the response
        for (var item in jsonResponse) {
          if (item.containsKey('custom') &&
              item['custom'].containsKey('total_score')) {
            String totalScore = item['custom']['total_score'].toString();
            await s.write(key: 'total_score', value: totalScore);
            // Perform additional actions with the total score
            print("Total Score: $totalScore");
            await sendBotScore(totalScore);
            print("Bot score sent successfully from first function");
          }
        }

        return jsonResponse.map((item) => ChatResponse.fromJson(item)).toList();
      } else {
        var jsonResponse = jsonDecode(response.body);

        print(error);
        return null;
      }
    } catch (e) {
      print('the error is: $e');
      return null;
    }
  }

  Future<void> sendBotScore(String score) async {
    try {
      await getToken();
      var response = await http.post(
        botscoreurl,
        headers: {"Accept": "application/json", "Authorization": _token},
        body: {"score": score},
      );
      print("botscoreurl: $botscoreurl");

      print("response.statusCode: ${response.statusCode}");
      print("response.body: ${response.body}");
      if (response.statusCode == 200) {
        print("Bot score sent successfully");
      } else {
        print("Failed to send bot score");
      }
    } catch (e) {
      print('the error is: $e');
    }
  }
}
