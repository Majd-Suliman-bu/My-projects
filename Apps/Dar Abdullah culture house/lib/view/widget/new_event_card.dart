// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker_app/constant/fonts.dart';
import 'package:worker_app/constant/text_style.dart';

import '../../constant/server_const.dart';
import '../../data/Models/event_model.dart';
import '../../main.dart';

class NewEventCard extends StatelessWidget {
  final EventModel event;
  const NewEventCard({super.key, required this.event});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        prefService.createString('eventId',event.id.toString());
        Get.toNamed('/EventInfo');
      },
      child: Container(
          height: 85, //Get.size.height * .12,
          width: Get.size.width * .95,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
                width: 0.2,
              ),
              color: Get.isDarkMode
                  ? const Color.fromARGB(255, 54, 54, 54)
                  : Colors.grey[400],
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(400),
                  bottomRight: Radius.circular(400))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: sharedPreferences!.getString('lang') != 'ar',
                replacement: eventImage(),
                child: dateBox(),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.size.width * .45,
                      child: Text(event.title,
                          overflow: TextOverflow.ellipsis,
                          style: generalTextStyle(20)),
                    ),
                    timeContainer(
                        "${event.beginDate.hour}:${event.beginDate.minute}"),
                  ],
                ),
              ),
              Visibility(
                visible: sharedPreferences!.getString('lang') != 'ar',
                replacement: dateBox(),
                child: eventImage(),
              ),
            ],
          )),
    );
  }

  Widget dateBox() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: dateContainer(event.beginDate.month.toString(),
          event.beginDate.day.toString(), event.beginDate.dayName ?? "NO"),
    );
  }

  Widget eventImage() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.6, top: 6, right: 6, bottom: 6),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(900),
              border: Border.all(
                color: Colors.black54,
                width: 0.2,
              )),
          width: Get.size.width * .2,
          height: Get.size.width * .2,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(900),
              child: event.images.isEmpty
                  ? Image.asset('assets/images/The project icon.jpg',
                      fit: BoxFit.fill)
                  : Image.network(
                      "${ServerConstApis.loadImages}${event.images[0].picture}",
                      fit: BoxFit.fill, errorBuilder: (context, Exception, StackTrace) {
                      return Image.asset('assets/images/The project icon.jpg',
                          fit: BoxFit.fill);
                    },))),
    );
  }

  Widget timeContainer(String time) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      height: 28.3, //Get.size.height * .04,
      width: Get.size.width * .22,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black54,
            width: 0.2,
          ),
          color: const Color.fromARGB(255, 199, 214, 213),
          borderRadius: const BorderRadius.all(Radius.circular(100))),
      child: Center(
          child: Text(
        time,
        style: const TextStyle(color: Colors.black54),
      )),
    );
  }

  Widget dateContainer(String monthName, String dayNumber, String dayName) {
    return Container(
      height: 78, //Get.size.height * .11,
      width: 78, //Get.size.height * .11,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black54,
          width: 0.2,
        ),
        color: const Color.fromARGB(255, 184, 212, 210),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              monthName,
              style:
                  TextStyle(color: Colors.black26, fontFamily: jostFontFamily),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(dayNumber,
                style: TextStyle(fontSize: 31, fontFamily: jostFontFamily)),
          ),
          Expanded(
            flex: 1,
            child: Text(dayName,
                style: TextStyle(
                    color: Colors.black26, fontFamily: jostFontFamily)),
          ),
        ],
      ),
    );
  }
}

class Event {
  final List<String> imagesNames;
  final String eventName;
  final List<String> artistsNames;
  final String description;
  final double ticketsPrice;
  final int availablePlaces;
  final Date beginDate;

  Event({
    required this.imagesNames,
    required this.eventName,
    required this.artistsNames,
    required this.description,
    required this.ticketsPrice,
    required this.availablePlaces,
    required this.beginDate,
  });
}

class Date {
  String dayName;
  String dayNumber;
  String month;
  String year;
  String time;
  Date({
    required this.dayName,
    required this.dayNumber,
    required this.month,
    required this.year,
    required this.time,
  });
}

// class EventCardController extends GetxController {
//   final RxInt pageIndex = 0.obs;
//   final PageController pageController = PageController();

//   get statuseRequest => null;

//   @override
//   void onClose() {
//     pageController.dispose();
//     super.onClose();
//   }

//   void setPageIndex(int index) {
//     pageIndex.value = index;
//   }

//   void onSlide(int direction) {
//     if (direction == 1) {
//       pageController.nextPage(
//           duration: const Duration(milliseconds: 300), curve: Curves.ease);
//     } else {
//       pageController.previousPage(
//           duration: const Duration(milliseconds: 300), curve: Curves.ease);
//     }
//   }
// }
