import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sized_context/sized_context.dart';
import '../../constant/fonts.dart';
import '../../constant/sizes.dart';
import '../../constant/theme.dart';
import '../../main.dart';
import '../screens/settings/setting_page.dart';

// ignore: must_be_immutable
class ProjectDrawer extends StatelessWidget {
  ProjectDrawer({super.key});
  SlideDrawerController controller = Get.put(SlideDrawerController());
  @override
  Widget build(BuildContext context) {
    Sizes size = Sizes(context);
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: 250,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: sharedPreferences!.getString('lang') == 'en'
                  ? Alignment.bottomRight
                  : sharedPreferences!.getString('lang') == 'ar'
                      ? Alignment.bottomLeft
                      : Alignment.bottomRight,
              end: sharedPreferences!.getString('lang') == 'en'
                  ? Alignment.topLeft
                  : sharedPreferences!.getString('lang') == 'ar'
                      ? Alignment.topRight
                      : Alignment.topLeft,
              colors: [
                Get.isDarkMode ? darkPrimaryColor : primaryColor,
                context.heightInches < 5
                    ? Get.isDarkMode
                        ? backGroundDarkColor.withOpacity(0.7)
                        : skinColorWhite!
                    : Get.isDarkMode
                        ? darkPrimaryColor
                        : primaryColor,
                Get.isDarkMode
                    ? backGroundDarkColor.withOpacity(0.7)
                    : skinColorWhite!,
                Get.isDarkMode
                    ? backGroundDarkColor.withOpacity(0.7)
                    : skinColorWhite!,
                Get.isDarkMode
                    ? backGroundDarkColor.withOpacity(0.7)
                    : skinColorWhite!,
              ]),
        ),
        child: drawerChildren(context, size),
      ),
    );
  }

  Widget drawerChildren(BuildContext context, Sizes size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: Get.size.height * .02),
          mainDrawerChid(context),
          const Divider(),
          SizedBox(height: Get.size.height * .02),
          SizedBox(height: Get.size.height * .02),
          drawerChid(context, Icons.storage_rounded, 'Stock', () {
            Get.toNamed('/StockPage');
          }),
          SizedBox(height: Get.size.height * .02),
          Visibility(
            visible: Get.currentRoute != '/EventPage',
            child: drawerChid(context, Icons.event, 'Events', () {
              Get.offAllNamed('/EventPage');
            }),
          ),
          SizedBox(height: Get.size.height * .02),
          drawerChid(context, Icons.settings, 'Settings', () {
            showSettingsDialog(context);
          }),
        ]),
      ),
    );
  }

  Widget mainDrawerChid(BuildContext context) {
    return Row(children: [
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
            width: 32,
            child: ClipOval(
                child: Image.asset('assets/images/The project icon.jpg'))),
      ),
      Visibility(
        replacement: const Text(''),
        visible: controller.checkIfTextVisible(),
        child: Flexible(
          fit: FlexFit.tight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: AutoSizeText(
              'Dar abdullah'.tr,
              maxLines: 1,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor,
                  fontFamily: jostFontFamily),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget drawerChid(BuildContext context, IconData icons, String title,
      Function()? onPressed) {
    return MaterialButton(
      onPressed: onPressed,
      child: Row(children: [
        Icon(
          icons,
          color: Get.isDarkMode ? darkPrimaryColor : primaryColor,
        ),
        Visibility(
          replacement: const Text(''),
          visible: controller.checkIfTextVisible(),
          child: Flexible(
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AutoSizeText(
                title.tr,
                maxLines: 1,
                style: TextStyle(
                    color:
                        Get.isDarkMode ? skinColorWhite : backGroundDarkColor,
                    fontFamily: jostFontFamily),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  void showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Setting(),
        );
      },
    );
  }
}

class SlideDrawerController extends GetxController {
  RxBool isClicked = true.obs;
  RxBool isHover = false.obs;
  Function(bool)? changeDrawerState() {
    isClicked.value = !isClicked.value;
    return isClicked;
  }

  Function(bool)? changeDrawerStateWhenHover() {
    isHover.value = !isHover.value;
    return isHover;
  }

  double setWidth(double smallWidth, double bigWidth) {
    return isClicked.value && isHover.value
        ? bigWidth
        : !isClicked.value && isHover.value
            ? bigWidth
            : isClicked.value && !isHover.value
                ? bigWidth
                : smallWidth;
  }

  bool checkIfTextVisible() {
    return isClicked.value || isHover.value;
  }
}
