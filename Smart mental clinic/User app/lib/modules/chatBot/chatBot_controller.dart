import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_medical_clinic/modules/chatBot/chatBot_service.dart';
import '../../models/chatMessage.dart';
import 'dart:convert';

import '../../models/chatResponse.dart';

class ChatBotController extends GetxController {
  var messages = <ChatMessage>[].obs;
  List<ChatMessage> allMessages = [];
  final String currentUser =
      'user1'; // Change this to a unique identifier for the user
  ChatbotService service = ChatbotService();
  var loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllMessages();
  }

  void updateMessage(ChatMessage message, {bool? isClickable}) {
    int index = allMessages.indexOf(message);
    if (index != -1) {
      allMessages[index] = ChatMessage(
        text: message.text,
        isSentByMe: message.isSentByMe,
        timestamp: message.timestamp,
        isClickable: isClickable ?? message.isClickable,
      );
      messages[index] = allMessages[index];
      saveMessages();
    }
  }

  void updateAllRelatedMessages(DateTime timestamp) {
    allMessages
        .removeWhere((msg) => msg.timestamp == timestamp && msg.isClickable);
    messages
        .removeWhere((msg) => msg.timestamp == timestamp && msg.isClickable);
    saveMessages();
  }

  void updateAllClickableMessages() {
    allMessages.removeWhere((msg) => msg.isClickable);
    messages.removeWhere((msg) => msg.isClickable);
    saveMessages();
  }

  Future<void> loadAllMessages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? messagesJson = prefs.getStringList('chat_messages');
    if (messagesJson != null) {
      allMessages = messagesJson
          .map((msg) => ChatMessage.fromJson(json.decode(msg)))
          .toList();
      allMessages.sort((a, b) =>
          a.timestamp.compareTo(b.timestamp)); // Sort messages by timestamp
      messages.assignAll(allMessages);
    }
  }

  Future<void> saveMessages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Ensure allMessages is up to date and sorted
    allMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    List<String> messagesJson =
        allMessages.map((msg) => json.encode(msg.toJson())).toList();
    await prefs.setStringList('chat_messages', messagesJson);
  }

  void addMessage(String text, bool isSentByMe,
      {bool isClickable = false, DateTime? timestamp}) async {
    var newMessage = ChatMessage(
      text: text,
      isSentByMe: isSentByMe,
      timestamp: timestamp ?? DateTime.now(),
      isClickable: isClickable, // Set isClickable
    );
    allMessages.add(newMessage); // Add new message at the end
    await saveMessages();
    messages.add(newMessage); // Display new message immediately
  }

  Future<void> getBotResponse(String msg) async {
    // Add the user's message to the list
    addMessage(msg, true);

    loading.value = true;
    List<ChatResponse>? responses = await service.getQuestion(msg);
    loading.value = false;
    if (responses != null) {
      for (var response in responses) {
        // Add the bot's response message
        DateTime responseTimestamp = DateTime.now();
        if (response.text != null) {
          addMessage(response.text!, false, timestamp: responseTimestamp);
        }

        // If there are buttons, add them as clickable messages
        if (response.buttons != null) {
          for (var button in response.buttons!) {
            addMessage(button.title, false,
                isClickable: true, timestamp: responseTimestamp);
          }
        }

        // If there is custom data, add the doctor information
        if (response.custom != null) {
          if (response.custom!.doctorName != null) {
            addMessage(
              'اسم الطبيب: ${response.custom!.doctorName}\nالمدينة: ${response.custom!.doctorCity}',
              false,
              timestamp: responseTimestamp,
              // isClickable: true,
            );
          }
        }
      }
    }
  }

  Future<void> deleteAllMessages() async {
    print("ssssssssssssssssssssssssssssssssssssssssssssss");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_messages'); // Remove the stored messages
    allMessages.clear(); // Clear the in-memory list
    messages.clear(); // Clear the observable list
  }
}
