// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker_app/constant/text_style.dart';
import 'package:worker_app/data/Models/drink_model.dart';

import '../../constant/server_const.dart';
import '../../constant/sizes.dart';
import '../../constant/theme.dart';

// ignore: must_be_immutable
class StockDrinkCard extends StatelessWidget {
  // StockCardController controller = Get.put(StockCardController());
  final Function() onPressed;
  final DrinkModel model;
  StockDrinkCard(this.onPressed, this.model);
  @override
  Widget build(BuildContext context) {
    Sizes size = Sizes(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Get.isDarkMode ? skinColorWhite! : backGroundDarkColor),
            color: Get.isDarkMode
                ? darkWoodBrownColor.withOpacity(0.9)
                : woodBrownColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(size.buttonRadius)),
        width: 100, //size.drinkCardWidth,
        height: 210,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.buttonRadius),
                    topRight: Radius.circular(size.buttonRadius),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: model.image == ''
                            ? Image.asset(
                                'assets/images/The project icon.jpg',
                                fit: BoxFit.fill,
                              )
                            : Image.network(
                                "${ServerConstApis.loadImages}${model.image}",
                                fit: BoxFit.fill, errorBuilder: (context, Exception, StackTrace) {
                      return Image.asset('assets/images/The project icon.jpg',
                          fit: BoxFit.fill);
                    },
                              ),
                      ),
                      Positioned.fill(
                        child: Container(
                          color: backGroundDarkColor.withOpacity(0.2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 6,
                            ),
                            const Spacer(),
                            Text(
                              model.quantity.toString(),
                              style: TextStyle(
                                color: skinColorWhite,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: AutoSizeText(
                  model.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: generalTextStyle(17),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              AutoSizeText(
                '${model.price} S.P',
                style: generalTextStyle(15),
              ),
            ]),
      ),
    );
  }
}
