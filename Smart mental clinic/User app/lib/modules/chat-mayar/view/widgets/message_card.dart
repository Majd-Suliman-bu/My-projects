import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_medical_clinic/main.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/helper-stuff/build_hero_full_image_page.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/helper-stuff/network_image.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/models/message_model.dart';

class MessageCard extends StatelessWidget {
  final String? text;
  final String date;
  final Uri? imageData;
  final bool iAmTheSender;
  final bool isConsecutiveMessage;
  final MessageTypeEnum messageType;

  const MessageCard({
    Key? key,
    required this.text,
    required this.date,
    this.imageData,
    required this.iAmTheSender,
    required this.isConsecutiveMessage,
    required this.messageType,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String time = formatTime(date);
    String day = getDayFromDate(date);

    switch (messageType) {
      case MessageTypeEnum.text:
        return GestureDetector(
          onLongPress: () {
            showGuestDialog(context, time, day, text ?? 'Unknown'.tr);
          },
          child: BubbleSpecialOne(
            text: '$text\n$time',
            textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: Get.size.width > 700 ? 17 : 14)
                .copyWith(color: Colors.white),
            tail: isConsecutiveMessage,
            color: iAmTheSender
                ? const Color.fromARGB(255, 25, 93, 219)
                : const Color(0xff36B4FF),
            isSender: iAmTheSender,
          ),
        );
      case MessageTypeEnum.image:
        return imageData == null
            ? const SizedBox.shrink()
            : messageImageCard(context, time, day);
      default:
        return const SizedBox.shrink();
    }
  }

  GestureDetector messageImageCard(
      BuildContext context, String time, String day) {
    return GestureDetector(
      onLongPress: () {
        showGuestDialog(context, time, day, 'Image'.tr);
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FullScreenImagePage(
                    heroTag: imageData!.toString(),
                    imageName: imageData!.toString(),
                  )),
        );
      },
      child: Hero(
        tag: imageData!.toString(),
        child: Align(
            alignment: iAmTheSender ? Alignment.topRight : Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: responsiveUtil.screenWidth * .42,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue)),
                child: Column(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: getImageNetwork(
                          fromBackEnd: false,
                          url: imageData!.toString(),
                          width: responsiveUtil.screenWidth * .4,
                          height: responsiveUtil.screenWidth * .4,
                        )),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.white, fontSize: 15)
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

String formatTime(String timeString) {
  try {
    DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    late DateTime dateTime;
    try {
      dateTime = inputFormat.parse(timeString);
    } catch (e) {
      dateTime = DateTime.now();
    }
    DateFormat outputFormat = DateFormat("hh:mm a");
    return outputFormat.format(dateTime);
  } catch (e) {
    debugPrint("Error parsing time string: $timeString");
    return "Invalid date".tr;
  }
}

String getDayFromDate(String timeString) {
  try {
    DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dateTime = inputFormat.parse(timeString);
    DateFormat dayFormat = DateFormat("EEEE, MMMM d, yyyy");
    return dayFormat.format(dateTime);
  } catch (e) {
    debugPrint("Error parsing date string: $timeString");
    return "Invalid date".tr;
  }
}

void showGuestDialog(
    BuildContext context, String time, String day, String text) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        alignment: Alignment.center,
        contentPadding: EdgeInsets.zero, // Removes default padding
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20)), // Removes default rounded corners
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.black),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    '${'The Message:'.tr} $text',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    // style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    '${'Day:'.tr} $day on $time',
                    // style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}
