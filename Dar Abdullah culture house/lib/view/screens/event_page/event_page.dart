import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker_app/view/widget/new_event_card.dart';
import '../../../constant/sizes.dart';
import '../../../constant/status_request.dart';
import '../../../constant/text_style.dart';
import '../../../constant/theme.dart';
import '../../widget/animation_title.dart';
import '../../widget/drawer.dart';
import '../../widget/no_internet_page.dart';
import 'event_page_controller.dart';

// ignore: must_be_immutable
class EventPage extends StatelessWidget {
  EventPageController controller = Get.find();
  EventPage({super.key});
  @override
  Widget build(BuildContext context) {
    Sizes size = Sizes(context);
    return Scaffold(
      drawer: ProjectDrawer(),
      appBar: createAppBar(size),
      body: GetBuilder<EventPageController>(
        builder: (ctx) =>
            controller.statuseRequest == StatuseRequest.offlinefailure
                ? noInternetPage(size, controller)
                : controller.statuseRequest == StatuseRequest.loading
                    ? Text("....".tr, style: generalTextStyle(14))
                    : whenShowTheBodyAfterLoadingAndInternet(context),
      ),
    );
  }

  Widget whenShowTheBodyAfterLoadingAndInternet(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            color: Get.isDarkMode ? darkPrimaryColor : primaryColor,
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              color: Get.isDarkMode ? backGroundDarkColor : skinColorWhite,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
          ),
          buildEventGridView()
        ],
      ),
    );
  }

  Widget buildEventGridView() {
    return ListView.builder(
      itemCount: controller.finalListData.length, //events.length - 1,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: NewEventCard(event: controller.finalListData[index]),
          // events[index],
        );
      },
    );
  }

  PreferredSizeWidget? createAppBar(Sizes size) {
    return AppBar(
      elevation: 0.4,
      backgroundColor: Get.isDarkMode ? darkPrimaryColor : primaryColor,
      title: AnimationAppBarTitle(title: 'Events'.tr),
    );
  }
}
