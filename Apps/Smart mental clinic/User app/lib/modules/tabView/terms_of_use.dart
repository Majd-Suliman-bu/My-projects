import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/helper-stuff/show_bottom_sheet.dart';
import 'package:smart_medical_clinic/shared_widget/app_strings.dart';

Future<dynamic> termOfUseBottomSheet(BuildContext context) {
  return showBottomSheetWidget(
      context,
      Container(
          decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * .8,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'SMC App Usage Policy'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                middelTitle('1. Introduction'.tr),
                normalDescription(AppString.introduction),
                const SizedBox(
                  height: 10,
                ),
                middelTitle('2. Acceptance of Terms'.tr),
                normalDescription(AppString.acceptanceOfTerms),
                const SizedBox(
                  height: 10,
                ),
                middelTitle('3. Account Registration and Security'.tr),
                normalDescription(AppString.accountRegistrationAndSecurity1),
                normalDescription(AppString.accountRegistrationAndSecurity2),
                const SizedBox(
                  height: 10,
                ),
                middelTitle('4. Use of the App'.tr),
                normalDescription(AppString.useOfTheApp1),
                normalDescription(AppString.useOfTheApp2),
                const SizedBox(
                  height: 10,
                ),
                middelTitle('5. Intellectual Property'.tr),
                normalDescription(AppString.intellectualPropertyRights),
                normalDescription(AppString.intellectualPropertyRights2),
                const SizedBox(
                  height: 10,
                ),
                middelTitle('6. Registration as a Service Provider'.tr),
                normalDescription(AppString.registrationAsServiceProvider1),
                normalDescription(AppString.registrationAsServiceProvider2),
                const SizedBox(
                  height: 10,
                ),
                middelTitle('7. Cancellation and Refund'.tr),
                normalDescription(AppString.cancellationAndRefund),
                const SizedBox(
                  height: 10,
                ),
                middelTitle('8. Disclaimer and Limitations'.tr),
                normalDescription(AppString.disclaimerAndLimitations),
                const SizedBox(
                  height: 10,
                ),
                middelTitle('9. Contact and Support'.tr),
                normalDescription(AppString.contactAndSupportPartOne),
                const SizedBox(
                  height: 10,
                ),
                normalDescription(AppString.contactAndSupportPartTwo),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ))));
}

Widget middelTitle(
  String title,
) {
  return SizedBox(
    width: Get.size.width * 0.8,
    child: Text(
      title.tr,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      overflow: TextOverflow.fade,
    ),
  );
}

Widget normalDescription(String description) {
  return SizedBox(
    width: Get.size.width * .9,
    child: Text(
      description.tr,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      overflow: TextOverflow.fade,
    ),
  );
}
