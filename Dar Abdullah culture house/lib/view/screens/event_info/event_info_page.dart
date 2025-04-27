import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/fonts.dart';
import '../../../constant/server_const.dart';
import '../../../constant/sizes.dart';
import '../../../constant/status_request.dart';
import '../../../constant/text_style.dart';
import '../../../constant/theme.dart';
import '../../widget/no_internet_page.dart';
import 'event_info_controller.dart';

class EventInfo extends StatelessWidget {
  EventInfo({super.key});
  // final EventCardController controller = Get.find();
  final EventInfoController dataController = Get.find();
  @override
  Widget build(BuildContext context) {
    Sizes size = Sizes(context);
    return GetBuilder<EventInfoController>(
      builder: (ctx) => dataController.statuseRequest ==
              StatuseRequest.offlinefailure
          ? noInternetPage(size, dataController)
          : dataController.statuseRequest == StatuseRequest.loading
              ? Center(
                  child: Text("hgfhgfgfdtsctdstcstctr".tr, style: generalTextStyle(14)))
              : whenShowTheBodyAfterLoadingAndInternet(context, size),
    );
  }

  whenShowTheBodyAfterLoadingAndInternet(BuildContext context, Sizes size) {
    return Scaffold(
      body: SafeArea(child: cardBody(size)),
      floatingActionButton: dataController.isConfirmed
          ? FloatingActionButton.extended(
              onPressed: () {},
              label: TextButton(
                onPressed: () {
                  Get.offNamed('/Bar', arguments: dataController.eventId);
                },
                child: Text(
                  'Work here'.tr,
                  style: generalTextStyle(null),
                ),
              ),
            )
          : null,
    );
  }

  Widget cardBody(Sizes size) {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 250,
              child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    const velocityThreshold = 2.0;
                    if (details.velocity.pixelsPerSecond.dx.abs() >
                        velocityThreshold) {
                      final direction =
                          details.velocity.pixelsPerSecond.dx.isNegative
                              ? -1
                              : 1;
                      dataController.onSlide(direction);
                    }
                  },
                  onTap: () {},
                  child: buildImagesList(size)),
            ),
            const SizedBox(height: 3),
            buildDots(),
            eventInfo(),
          ],
        )));
  }

  Widget eventInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(height: 5),
          const Divider(
            height: 10,
          ),
          Text(
            dataController.model.title,
            style: TextStyle(
                color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor,
                fontSize: 23,
                fontFamily: jostFontFamily,
                fontWeight: FontWeight.bold),
          ),
          const Divider(
            height: 10,
          ),
          setEventINfo(
              '${'Artists: '.tr}${dataController.model.artist.map((artist) => artist.artistName).join(', ')}'),
          elementDivider(),
          const SizedBox(height: 3),
          setEventINfo(
            '${'Date: '.tr}${dataController.model.beginDate.day}/${dataController.model.beginDate.month}/${dataController.model.beginDate.year}',
          ),
          elementDivider(),
          const SizedBox(height: 3),
          setEventINfo(
            'Available Places: '.tr +
                dataController.model.availablePlaces.toString(),
          ),
          elementDivider(),
          const SizedBox(height: 3),
          setEventINfo(
            '${'Ticket Price: '.tr}${dataController.model.ticketPrice} ${'S.P'.tr}',
          ),
          elementDivider(),
          const SizedBox(height: 3),
          setEventINfo('Description: '.tr + dataController.model.description),
        ],
      ),
    );
  }

  Widget elementDivider() {
    return const Divider(endIndent: 200);
  }

  Widget buildImagesList(Sizes size) {
    return AnimatedBuilder(
      animation: dataController.pageController,
      builder: (context, child) {
        return dataController.model.images.isEmpty
            ? Image.asset(
                'assets/images/The project icon.jpg',
                fit: BoxFit.fill,
              )
            : PageView.builder(
                onPageChanged: dataController.setPageIndex,
                controller: dataController.pageController,
                itemCount: dataController.model.images.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(size.buttonRadius),
                        topRight: Radius.circular(size.buttonRadius),
                      ),
                      child: Image.network(
                          "${ServerConstApis.loadImages}${dataController.model.images[index].picture}",
                          fit: BoxFit.fill, errorBuilder: (context, Exception, StackTrace) {
                      return Image.asset('assets/images/The project icon.jpg',
                          fit: BoxFit.fill);
                    },));
                },
              );
      },
    );
  }

  Widget buildDots() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          dataController.eventModelImageLengh.value,
          (index) => buildDot(
              index: index, currentIndex: dataController.pageIndex.value),
        ),
      );
    });
  }

  Widget setEventINfo(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: AutoSizeText(title, style: generalTextStyle(15)),
    );
  }

  Widget buildDot({required int index, required int currentIndex}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(5),
      height: 6,
      width: index == currentIndex ? 20 : 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: index == currentIndex
            ? (Get.isDarkMode ? darkPrimaryColor : primaryColor)
            : const Color(0xFFD8D8D8),
      ),
    );
  }
}
