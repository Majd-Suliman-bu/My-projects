// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker_app/constant/fonts.dart';
import 'package:worker_app/view/widget/cart_card.dart';
import 'package:worker_app/view/widget/my_button.dart';

import '../../../constant/sizes.dart';
import '../../../constant/theme.dart';
import '../../../data/Models/drink_model.dart';
import '../../widget/animation_title.dart';
import 'cart_controller.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});
  final CartController controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    final Sizes size = Sizes(context);
    return Scaffold(
      appBar: createAppBar(size),
      body: Column(
        children: [
          SizedBox(
            height: Get.size.height * .7,
            child: ListView.builder(
                itemCount: controller.order.drinksWithAmount.length,
                itemBuilder: ((context, index) {
                  print(index);
                  return cartCard(controller.order, index, context, size);
                  // cartElement(order, index, context, size)
                })),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${'Total price'.tr}: ${controller.order.calculateTotalPrice()}S.P',
              style: TextStyle(
                fontFamily: jostFontFamily,
                color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: MyButton(
              mycolor: Get.isDarkMode ? darkPrimaryColor : primaryColor,
              myRadius: size.buttonRadius,
              ontap: () {
                controller.onpressDone();
Navigator.of(context).pop();
                //send the data to the backend and go back to the prev page.
              },
              mywidth: size.normalButtonWidht,
              myheight: size.normalButtonHeight,
              myShadow: 0,
              child: AutoSizeText(
                'Done'.tr,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: size.normalButtonTextSize,
                    fontFamily: jostFontFamily,
                    color:
                        Get.isDarkMode ? skinColorWhite : backGroundDarkColor),
              ),
            ),
          )
        ],
      ),
    );
  }

  PreferredSizeWidget? createAppBar(Sizes size) {
    return AppBar(
      iconTheme: IconThemeData(
          color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor),
      elevation: 0.4,
      backgroundColor: Get.isDarkMode ? darkPrimaryColor : primaryColor,
      title: AnimationAppBarTitle(title: 'Cart page'.tr),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor,
            size: size.appBarIconSize,
          ),
          onPressed: () {
            // Perform search action
          },
        ),
      ],
    );
  }
}

class MakeOrder {
  List<DrinkAmount> drinksWithAmount = [];
  double calculatePrice(int id) {
    double price = 0;
    for (int i = 0; i < drinksWithAmount[id].amount.toInt(); i++) {
      price += drinksWithAmount[id].drink.price;
    }
    return price;
  }

  double calculateTotalPrice() {
    double totalPrice = 0;
    for (var element in drinksWithAmount) {
      for (int i = 0; i < element.amount; i++) {
        totalPrice += element.drink.price;
      }
    }
    return totalPrice;
  }

  void makeTheOrderEmpty() {
    drinksWithAmount = [];
  }
}

class DrinkAmount {
  DrinkModel drink;
  int amount;
  DrinkAmount({
    required this.drink,
    required this.amount,
  });
}
