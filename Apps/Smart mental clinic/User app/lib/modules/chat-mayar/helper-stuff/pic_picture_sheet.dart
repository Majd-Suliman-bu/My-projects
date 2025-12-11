import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_medical_clinic/main.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/view/screens/chat_page.dart';

Widget buildimageSourcesBottomSheet(BuildContext context,
    {required Future<void> Function(ImageSource source, BuildContext context)
        pickImage}) {
  return Container(
    // color: customColors.secondaryBackGround,
    height: responsiveUtil.screenHeight * .35,
    child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          choosePhotoSource(
            context: context,
            title: "chooseSource".tr,
            // textColor: customColors.secondaryText,
          ),
          const SizedBox(
            height: 15,
          ),
          choosePhotoSource(
              context: context,
              title: "gallery".tr,
              onPress: () {
                pickImage(ImageSource.gallery, context);

                Get.back();
              }),
          const SizedBox(
            height: 15,
          ),
          choosePhotoSource(
              context: context,
              title: "camera".tr,
              onPress: () {
                pickImage(ImageSource.camera, context);
                Get.back();
              })
        ]),
  );
}

Widget choosePhotoSource(
    {required BuildContext context,
    required String title,
    Color? textColor,
    Function()? onPress}) {
  return Container(
    width: double.infinity,
    height: 50,
    // decoration: BoxDecoration(
    //   color: customColors.secondaryBackGround,
    // ),
    child: Center(
      child: InkWell(
        onTap: onPress,
        child: Text(
          title,
          // style: const TextStyle(color: Colors.white, fontSize: 18).copyWith(
          //     fontFamily: 'Readex Pro',
          //     fontSize: 20,
          // fontWeight: FontWeight.w400,
          // color: customColors.primaryText
        ),
      ),
    ),
  );
}
