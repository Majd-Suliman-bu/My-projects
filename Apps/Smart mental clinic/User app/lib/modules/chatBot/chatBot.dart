import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/chatMessage.dart';
import 'chatBot_controller.dart';
import 'chatBot_service.dart';

class ChatBot extends StatelessWidget {
  final ChatBotController controller = Get.find();
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  ValueKey textFieldKey = ValueKey(DateTime.now().millisecondsSinceEpoch);
  ChatbotService chatbotService = ChatbotService();

  ChatBot() {
    // Add a listener to scroll to the bottom whenever messages are updated
    controller.messages.listen((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              // Hide keyboard when tapping outside
              FocusScope.of(context).unfocus();
              // Update the key to force rebuilding the text field, resetting its state
              textFieldKey = ValueKey(DateTime.now().millisecondsSinceEpoch);
              // Trigger a rebuild of the widget to apply the new key
              (context as Element).markNeedsBuild();
            },
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    // Check if there are no messages
                    if (controller.messages.isEmpty) {
                      // Display a button in the center
                      return Center(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.getBotResponse("مرحبا");
                          },
                          child: Text("Start Chat".tr),
                        ),
                      );
                    } else {
                      // Otherwise, display the list of messages
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: controller.messages.length,
                        itemBuilder: (context, index) {
                          final message = controller.messages[index];
                          final previousSender = index > 0
                              ? (controller.messages[index - 1].isSentByMe
                                  ? "Me".tr
                                  : "ChatBot".tr)
                              : null;
                          return _buildMessage(message, context,
                              previousSender: previousSender);
                        },
                      );
                    }
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        key: textFieldKey,
                        controller: textEditingController,
                        keyboardType: TextInputType
                            .multiline, // Allow for newline characters in the input
                        maxLines:
                            null, // Allows the input field to expand to accommodate more lines
                        decoration: InputDecoration(
                          hintText: "Type a message".tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                width: 1.0), // Color when not focused
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 2.0), // Color when focused
                          ),
                        ),
                      )),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          controller.deleteAllMessages();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          if (textEditingController.text.trim().isNotEmpty) {
                            controller.updateAllClickableMessages();
                            controller.getBotResponse(
                                textEditingController.text.trim());

                            textEditingController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message, BuildContext context,
      {String? previousSender}) {
    final isSentByMe = message.isSentByMe;
    final timeString = DateFormat('HH:mm').format(message.timestamp);
    final senderName = isSentByMe ? "Me" : "ChatBot";
    final showUsername = !isSentByMe && (previousSender != senderName);

    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showUsername)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 4),
              child: Text(
                senderName,
                style: TextStyle(
                  fontSize: MediaQuery.sizeOf(context).height * 0.02,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isSentByMe)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Text(
                    timeString,
                    style: TextStyle(
                      fontSize: MediaQuery.sizeOf(context).height * 0.017,
                      color: Colors.grey,
                    ),
                  ),
                ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    if (message.isClickable &&
                        message.text.startsWith('Doctor Name:')) {
                      controller.updateAllClickableMessages();
                    } else {
                      controller.getBotResponse(message.text);
                      controller.updateAllClickableMessages();
                    }
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    margin:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: isSentByMe
                          ? Colors.blue[200]
                          : (message.isClickable
                              ? Colors.green[200]
                              : Colors.grey[200]),
                      borderRadius: isSentByMe
                          ? BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            )
                          : BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                              topLeft: Radius.circular(12),
                            ),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        fontSize: MediaQuery.sizeOf(context).height * 0.024,
                        color: Colors.black,
                        decoration: message.isClickable
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
              if (!isSentByMe)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    timeString,
                    style: TextStyle(
                      fontSize: MediaQuery.sizeOf(context).height * 0.017,
                      color: Colors.grey,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
