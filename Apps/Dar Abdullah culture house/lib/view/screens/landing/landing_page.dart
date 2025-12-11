import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/fonts.dart';
import '../../../constant/sizes.dart';
import '../../../constant/theme.dart';
import '../../widget/my_button.dart';
import '../../widget/splash_item.dart';
import 'landing_controller.dart';

class Landing extends StatelessWidget {
  final OnBoardController controller = Get.put(OnBoardController());

  Landing({super.key});

  @override
  Widget build(BuildContext context) {
    final Sizes size = Sizes(context);

    return Scaffold(
      backgroundColor: Get.isDarkMode ? backGroundDarkColor : skinColorWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Get.size.height * 0.05),
              AutoSizeText(
                'dar abdallah management system'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: jostFontFamily,
                  fontSize: size.appBarTextSize,
                  fontWeight: FontWeight.bold,
                  color: Get.isDarkMode
                      ? Themes.customdarktheme.primaryColor
                      : Themes.customlighttheme.primaryColor,
                ),
              ),
              SizedBox(height: Get.size.height * 0.05),
              SizedBox(
                height: Get.size.height * 0.55,
                child: PageView.builder(
                  dragStartBehavior: DragStartBehavior.down,
                  controller:
                      PageController(initialPage: controller.pageIndex.value),
                  onPageChanged: controller.setPageIndex,
                  itemCount: controller.pageDetails.length,
                  itemBuilder: (context, index) {
                    return SplashItem(
                      title: controller.pageDetails[index]['title']!,
                      image: controller.pageDetails[index]['image']!,
                    );
                  },
                ),
              ),
              Column(
                children: [
                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.pageDetails.length,
                        (index) => buildDot(
                            index: index,
                            currentIndex: controller.pageIndex.value),
                      ),
                    );
                  }),
                  SizedBox(height: Get.size.height * 0.02),
                  MyButton(
                    myRadius: 5,
                    mywidth: size.wideNormalButtonWidth,
                    myheight: size.normalButtonHeight,
                    mycolor: Get.isDarkMode ? darkPrimaryColor : primaryColor,
                    ontap: () {
                      controller.onPress();
                      },
                    child: Text(
                      'Continue'.tr,
                      style: TextStyle(
                        fontSize: size.wideNormalButtonTextSize,
                        color: Get.isDarkMode
                            ? skinColorWhite
                            : backGroundDarkColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.size.height * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}

AnimatedContainer buildDot({required int index, required int currentIndex}) {
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

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}
