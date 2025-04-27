import 'package:get/get.dart';

import '../modules/chatBot/chatBot_controller.dart';

class ChatBotBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ChatBotController>(ChatBotController());
  }
}
