import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/helper-stuff/show_bottom_sheet.dart';
import 'package:smart_medical_clinic/shared_widget/agree_to_end_bottom_sheet.dart';
import 'package:smart_medical_clinic/shared_widget/report_video_call_bottom_sheet.dart';

Widget buildAppbarVedieCallMenu(BuildContext context, String appointmentId) {
  return PopupMenuButton<String>(
    color: Color(0xff14181b),
    icon: const CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.more_vert,
          color: Colors.white,
        )),
    onSelected: (value) async {
      if (value == 'Report') {
        await showBottomSheetWidget(
            context, videoCallReportBottomSheet(context, appointmentId));
      } else if (value == 'agree') {
        await showBottomSheetWidget(
            context, agreeToEndCallBottomSheet(context, appointmentId));
      }
    },
    itemBuilder: (BuildContext context) {
      return [
        PopupMenuItem<String>(
          value: 'agree',
          child: patientOptionText('agree to end call'),
        ),
        PopupMenuItem<String>(
          value: 'Report',
          child: patientOptionText('Report this video call'),
        ),
      ];
    },
  );
}

Text patientOptionText(String title) => Text(
      title.tr,
      style: const TextStyle(color: Colors.white, fontSize: 18),
    );
