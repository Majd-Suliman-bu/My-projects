import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker_app/constant/fonts.dart';
import 'package:worker_app/constant/sizes.dart';
import 'package:worker_app/constant/text_style.dart';
import 'package:worker_app/constant/theme.dart';
import 'package:worker_app/view/screens/cart/cart_page.dart';

Widget cartCard(MakeOrder order, int index, BuildContext context, Sizes size) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Get.isDarkMode ? darkPrimaryColor : primaryColor,
          width: 1.0,
        ),
      ),
      color: Get.isDarkMode
          ? const Color.fromARGB(255, 77, 77, 77)
          : Colors.grey[400],
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.drinksWithAmount[index].drink.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: jostFontFamily,
                color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('${'Price'.tr}: \$${order.calculatePrice(index)} S.P',
                style: generalTextStyle(16)),
            const SizedBox(height: 8),
            Text(
                '${'Amount Ordered'.tr}: ${order.drinksWithAmount[index].amount}',
                style: generalTextStyle(16)),
          ],
        ),
      ),
    ),
  );
}
