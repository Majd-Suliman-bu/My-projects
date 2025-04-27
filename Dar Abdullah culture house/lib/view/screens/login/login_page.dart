import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/fonts.dart';
import '../../../constant/sizes.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../constant/status_request.dart';
import '../../../constant/theme.dart';
import '../../widget/costum_text_field.dart';
import '../../widget/my_button.dart';
import '../../widget/no_internet_page.dart';
import 'login_controller.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  GetDeviceType getDeviceType = GetDeviceType();
  LoginController controller = Get.find();
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.isDarkMode ? backGroundDarkColor : skinColorWhite,
        body: bodyAllStatuse(context));
  }

  Widget bodyAllStatuse(BuildContext context) {
    Sizes size = Sizes(context);

    return GetBuilder<LoginController>(
      builder: (controller) {
        if (controller.statuseRequest == StatuseRequest.offlinefailure) {
          return noInternetPage(size, controller);
        } else {
          return bodyWithLoginElements(size, context);
        }
      },
    );
  }

  Widget bodyWithLoginElements(Sizes size, BuildContext context) {
    return Form(
      key: controller.formstate,
      child: Stack(
        children: [
          putBackgroundImage(context),
          Positioned(
            top: Get.size.height * .1,
            left: Get.size.width * .05,
            right: Get.size.width * .05,
            child: Container(
              width: Get.size.width * .4,
              height: Get.size.height * .8,
              //decoration: floatingContainerBoxDecoration(),
              child: theLoginColumnBody(size),
            ),
          ),
        ],
      ),
    );
  }

  Widget putBackgroundImage(BuildContext context) {
    return Positioned(
      top: -Get.size.height * .03,
      left: -Get.size.width * .025,
      child: ShaderMask(
        shaderCallback: (rect) {
          return const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.black, Colors.transparent],
          ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
        },
        blendMode: BlendMode.dstIn,
        child: Image.asset(
          fit: BoxFit.fill,
          'assets/images/medium page background image.jpg',
          width: Get.size.width,
          height: Get.height + Get.height * .1,
        ),
      ),
    );
  }

  Widget passwordTextFeild(Sizes size) {
    return Obx(
      () {
        return CostumTextField(
          labelStyle: TextStyle(
              color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor),
          widthOnTheScreen: size.textFieldWidth,
          onsaved: (value) {
            controller.password = value!;
          },
          hint: 'enter your password'.tr,
          hintStyle: TextStyle(
              fontFamily: jostFontFamily,
              color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor),
          label: "password".tr,
          suffixIcon: IconButton(
            onPressed: () {
              controller.changePasswordSecure();
            },
            icon: controller.passwordSecure.value
                ? const Icon(
                    Icons.visibility_off,
                  )
                : Icon(Icons.visibility,
                    color: Get.isDarkMode ? darkPrimaryColor : primaryColor),
          ),
          prefixIcon: Icon(Icons.password,
              color: Get.isDarkMode ? darkPrimaryColor : primaryColor),
          sucer: controller.passwordSecure.value,
          validat: (value) {
            if (value!.length < 4) {
              return "the password can't be smaller than 4 character ".tr;
            }
            return null;
          },
        );
      },
    );
  }

  Widget emailTextFeild(Sizes size) {
    return CostumTextField(
      labelStyle: TextStyle(
          color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor),
      widthOnTheScreen: size.textFieldWidth,
      onsaved: (value) {
        controller.email = value!;
      },
      hint: 'enter your email'.tr,
      hintStyle: TextStyle(
          fontFamily: jostFontFamily,
          color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor),
      label: "email".tr,
      prefixIcon: const Icon(
        Icons.email,
        // color: Get.isDarkMode ? darkPrimaryColor : primaryColor,
      ),
      sucer: false,
      validat: (value) {
        bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value!);
        if (!emailValid) {
          return (("The inpout isn't an eamil").tr);

          ///add for translate
        }
        return null;
      },
    );
  }

  MyButton theDoneButton(Sizes size) {
    return MyButton(
      mycolor: Get.isDarkMode ? darkPrimaryColor : primaryColor,
      myRadius: size.buttonRadius,
      ontap: () {
        print("object");
        controller.onpresslogin();
        // Get.offNamed('/Bar');
      },
      mywidth: size.normalButtonWidht,
      myheight: size.normalButtonHeight,
      myShadow: 0,
      child: controller.statuseRequest == StatuseRequest.loading
          ? Container(
              padding: const EdgeInsets.all(2),
              child: CircularProgressIndicator(
                color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor,
              ),
            )
          : AutoSizeText(
              'Done'.tr,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: size.normalButtonTextSize,
                  fontFamily: jostFontFamily,
                  color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor),
            ),
    );
  }

  SingleChildScrollView theLoginColumnBody(Sizes size) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: Get.size.height * .1,
          ),
          AutoSizeText(
            'Login'.tr,
            style: TextStyle(
                color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor,
                fontSize: size.appBarTextSize,
                fontFamily: jostFontFamily,
                fontWeight: FontWeight.w100),
          ),
          SizedBox(
            height: Get.size.height * .04,
          ),
          emailTextFeild(size),
          SizedBox(height: Get.size.height * .1),
          passwordTextFeild(size),
          SizedBox(height: Get.size.height * .1),
          theDoneButton(size),
          SizedBox(
            height: Get.size.height * .1,
          ),
        ],
      ),
    );
  }
}
