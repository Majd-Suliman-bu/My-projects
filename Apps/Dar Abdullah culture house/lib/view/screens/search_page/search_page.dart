import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sized_context/sized_context.dart';
import 'package:worker_app/constant/sizes.dart';
import 'package:worker_app/constant/text_style.dart';
import 'package:worker_app/constant/theme.dart';
import 'package:worker_app/view/screens/search_page/search_controller.dart';
import 'package:worker_app/view/widget/drink_card.dart';
import 'package:worker_app/view/widget/reservation_card.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});
  final int pageNumber = Get.arguments;
  final GeneralSearchController controller = Get.put(GeneralSearchController());
  final DrinkCardController drinkCardController = Get.find();
  @override
  Widget build(BuildContext context) {
    Sizes size = Sizes(context);
    return Scaffold(
        appBar: createAppBar(size),
        body: SafeArea(
            child: Stack(children: [
          Container(
            color: Get.isDarkMode ? darkPrimaryColor : primaryColor,
          ),
          createScreenStyle(),
          Visibility(
              visible: pageNumber == 0,
              replacement: createCustomerNamesListView(context, controller),
              child: createDrinkSearchGridView(context, drinkCardController)),
        ])));
  }

  Widget createScreenStyle() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? backGroundDarkColor : skinColorWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
    );
  }

  Widget createCustomerNamesListView(
      BuildContext context, GeneralSearchController controller) {
    return Obx(() =>ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: controller.customerSearchedListLength.value,
      itemBuilder: (context, index) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: ReservationCard(
              reservation: controller.finalSearchListData[index],
              index: index,
            ));
      },
    ));
  }

  Widget createDrinkSearchGridView(
      BuildContext context, DrinkCardController drinkCardController) {
    return Obx(() => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: context.widthInches > 8.5
                ? 4
                : context.widthInches > 5.5
                    ? 3
                    : 2,
            mainAxisExtent: 230,
            crossAxisSpacing: 10,
            mainAxisSpacing: 16,
          ),
          itemCount: controller.drinkSearchedListLength.value,
          itemBuilder: (context, index) {
            return DrinkCard(
              id: index,
              drink: controller.drinkSearchedList.isEmpty
                  ? drinkCardController.finalListData[index]
                  : controller.drinkSearchedList[index],
            );
          },
        ));
  }

  PreferredSizeWidget? createAppBar(Sizes size) {
    return AppBar(
      iconTheme: IconThemeData(
          color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor),
      backgroundColor: Get.isDarkMode ? darkPrimaryColor : primaryColor,
      actions: [
        SizedBox(
          width: Get.size.width * .9,
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'search'.tr, // Set the hint text to "search"
                hintStyle: TextStyle(
                    color: Get.isDarkMode
                        ? skinColorWhite
                        : backGroundDarkColor), // Set the hint text color to white
              ),
              style: generalTextStyle(null),
              onChanged: (text) {
                pageNumber == 0
                    ? {
                        controller.drinkSearch(text),
                        controller.drinkSearchedListLength.value =
                            controller.drinkSearchedList.length
                      }
                    :
                    
                    {
                        controller.customerSearch(text),
                        controller.customerSearchedListLength.value =
                            controller.finalSearchListData.length
                      };
              },
            ),
          ),
        )
      ],
    );
  }
}
