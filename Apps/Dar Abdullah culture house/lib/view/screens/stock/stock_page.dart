import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sized_context/sized_context.dart';
import 'package:worker_app/constant/sizes.dart';
import 'package:worker_app/constant/theme.dart';
import 'package:worker_app/view/screens/edite_drink_on_stock/edite_drink_on_stock_page.dart';
import 'package:worker_app/view/screens/stock/stock_controller.dart';
import 'package:worker_app/view/widget/animation_title.dart';

import '../../../data/Models/drink_model.dart';
import '../../widget/stock_drink_card.dart';
import '../add_new_drink_stock/add_new_drink_view.dart';

class Stock extends StatelessWidget {
  Stock({super.key});
  final StockController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    final Sizes size = Sizes(context);
    return GetBuilder<StockController>(builder: (ccontext) {
      return Scaffold(
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                showAddDrinkDialog(context);
              },
              child: Icon(
                Icons.add,
                color: Get.isDarkMode ? backGroundDarkColor : skinColorWhite,
              )),
          appBar: createAppBar(size),
          body: GridView.builder(
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
            itemCount: controller.finalListData.length,
            itemBuilder: (context, index) {
              //controller.addNewElement();
              return StockDrinkCard(
                () {
                  showEditeDrinkOnStockDialog(
                      context, controller.finalListData[index]);
                },
                controller.finalListData[index],
              );
            },
          ));
    });
  }

  PreferredSizeWidget? createAppBar(Sizes size) {
    return AppBar(
      elevation: 0.4,
      backgroundColor: Get.isDarkMode ? darkPrimaryColor : primaryColor,
      title: AnimationAppBarTitle(title: 'Stock Page'.tr),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor,
          size: size.appBarIconSize,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      // actions: [
      //   IconButton(
      //     icon: Icon(
      //       Icons.search,
      //       color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor,
      //       size: size.appBarIconSize,
      //     ),
      //     onPressed: () {
      //       // Perform search action
      //     },
      //   ),
      // ],
    );
  }
}

void showEditeDrinkOnStockDialog(BuildContext context, DrinkModel drink) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: EditeDrinkOnStockPage(drink),
      );
    },
  );
}

void showAddDrinkDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: AddNewDrink(),
      );
    },
  );
}
