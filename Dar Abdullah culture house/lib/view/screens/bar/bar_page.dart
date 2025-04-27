import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sized_context/sized_context.dart';
import 'package:worker_app/constant/text_style.dart';
import 'package:worker_app/view/screens/bar/bar_page_controller.dart';

import '../../../constant/sizes.dart';
import '../../../constant/theme.dart';
import '../../../main.dart';
import '../../widget/animation_title.dart';
import '../../widget/bottom_nav_bar.dart';
import '../../widget/drawer.dart';
import '../../widget/drink_card.dart';
import '../door/door_controller.dart';
import '../door/door_page.dart';
import '../orders/order_page.dart';

class BarPage extends StatelessWidget {
  const BarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Sizes size = Sizes(context);
    BarPageController controller = Get.find();
    // final DrinkSearchController drinkSearchController =
    //     Get.put(DrinkSearchController());
    final DrinkCardController drinkCardController =
        Get.put(DrinkCardController());
    return DefaultTabController(
        length: 1,
        initialIndex: 0,
        child: Scaffold(
          floatingActionButton: Obx(() => Visibility(
                visible: controller.page.value != 1,
                replacement: const Text(''),
                child: floatingDoneButton(controller, drinkCardController),
              )),
          extendBody: true,
          appBar: createAppBar(size, controller),
          drawer: ProjectDrawer(),
          body: SafeArea(
            child: Stack(
              children: [
                Container(
                  color: Get.isDarkMode ? darkPrimaryColor : primaryColor,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    color:
                        Get.isDarkMode ? backGroundDarkColor : skinColorWhite,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                ),
                Obx(() {
                  return TabBarView(
                    children: selectPage(
                        controller, context, drinkCardController, size),
                  );
                }),
              ],
            ),
          ),
          bottomNavigationBar: const BottomNavBar(),
        ));
  }

  Widget floatingDoneButton(
      BarPageController controller, DrinkCardController drinkCardController) {
    return Obx(() => SizedBox(
          height: 100,
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 500),
            alignment: controller.page.value == 2
                ? sharedPreferences!.getString('lang') == 'en'
                    ? Alignment.topRight
                    : sharedPreferences!.getString('lang') == 'ar'
                        ? Alignment.topLeft
                        : Alignment.topRight
                : sharedPreferences!.getString('lang') == 'en'
                    ? Alignment.bottomRight
                    : sharedPreferences!.getString('lang') == 'ar'
                        ? Alignment.bottomLeft
                        : Alignment.bottomRight,
            child: FloatingActionButton.extended(
                onPressed: () {
                  onpressedDone(controller.page.value, drinkCardController);
                },
                label: Text('Done'.tr, style: generalTextStyle(null))),
          ),
        ));
  }

  List<Widget> selectPage(BarPageController controller, BuildContext context,
      DrinkCardController drinkCardController, Sizes size) {
    List<Widget> list = [
      buildBarGridView(Colors.black, context, drinkCardController),
      // buildBarGridView(Colors.blue, context, drinkCardController),
      buildOrderList(size),
      attendanceList(context, controller.eventId),
    ];
    return ([list[controller.page.value]]);
  }

  Widget buildBarGridView(Color? color, BuildContext ccontext,
      DrinkCardController drinkCardContrller) {
    return GetBuilder(
        init: drinkCardContrller,
        builder: (context) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ccontext.widthInches > 8.5
                  ? 4
                  : ccontext.widthInches > 5.5
                      ? 3
                      : 2,
              mainAxisExtent: 230,
              crossAxisSpacing: 10,
              mainAxisSpacing: 16,
            ),
            itemCount: drinkCardContrller.finalListData.length,
            itemBuilder: (context, index) {
              return DrinkCard(
                id: index,
                drink: drinkCardContrller.finalListData[index],
              );
            },
          );
        });
  }

  PreferredSizeWidget? createAppBar(Sizes size, BarPageController controller) {
    return AppBar(
      elevation: 0.4,
      backgroundColor: Get.isDarkMode ? darkPrimaryColor : primaryColor,
      title: AnimationAppBarTitle(title: 'Worker app'.tr),
      actions: [
        Obx(()=>Visibility(
          visible: controller.page.value!=1,
          child: IconButton(
            icon: Icon(
              Icons.search,
              color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor,
              size: size.appBarIconSize,
            ),
            onPressed: () {
              Get.toNamed('/SearchPage', arguments: controller.page.value);
            },
          ),
        )),
      ],
    );
  }

  void onpressedDone(int index, DrinkCardController drinkCardController) {
    if (index == 0) {
      Get.toNamed('/Cart', arguments: drinkCardController.order);
    } else if (index == 2) {
      DoorController controller = Get.find();
      controller.sendData();
    }
  }
}
