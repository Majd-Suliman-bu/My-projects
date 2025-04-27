// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker_app/constant/sizes.dart';
import 'package:worker_app/view/widget/divider_with_word.dart';

import '../../../constant/status_request.dart';
import '../../../constant/text_style.dart';
import '../../widget/no_internet_page.dart';
import '../../widget/reservation_card.dart';
import 'door_controller.dart';

Widget attendanceList(BuildContext context, int eventId) {
  Sizes size = Sizes(context);
  DoorController controller = Get.put(DoorController());
  controller.eventID = eventId;
  return GetBuilder<DoorController>(
    builder: (ctx) => controller.statuseRequest == StatuseRequest.offlinefailure
        ? noInternetPage(size, controller)
        : controller.statuseRequest == StatuseRequest.loading
            ? Text("loading....".tr, style: generalTextStyle(14))
            : whenShowTheBodyAfterLoadingAndInternet(context, controller),
  );
}

whenShowTheBodyAfterLoadingAndInternet(context, DoorController controller) {
  Widget getnotcome() {
    List<Widget> h = [];
    for (var i = 0; i < controller.finalListDataNotCome.length; i++) {
      h.add(ReservationCard(
          reservation: controller.finalListDataNotCome[i],
          index: controller.finalListDataCome.length + i));
    }
    return Column(
      children: h,
    );
  }

  Widget getcome() {
    List<Widget> g = [];
    for (var i = 0; i < controller.finalListDataCome.length; i++) {
      g.add(ReservationCard(
          reservation: controller.finalListDataCome[i], index: i));
    }
    return Column(
      children: g,
    );
  }

  List<Widget> getData() {
    List<Widget> h = [];
    h.add(dividerWithWord('Have not come yet'.tr));
    h.add(getnotcome());
    h.add(dividerWithWord('Have already came'.tr));
    h.add(getcome());
    return h;
  }

  List<Widget> finall = getData();
  return ListView.builder(
    padding: const EdgeInsets.symmetric(vertical: 20),
    itemCount: finall.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: finall[index],
      );
    },
  );
}

class Reservation {
  String name;
  int totalNumber;
  int cameNumber;
  int eventId;
  int id;

  Reservation({
    required this.name,
    required this.totalNumber,
    required this.cameNumber,
    required this.eventId,
    required this.id,
  });
}
