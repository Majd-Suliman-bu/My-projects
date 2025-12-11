import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:smart_medical_clinic/modules/videoCall/bloc/video_call_bloc.dart';
import 'package:smart_medical_clinic/shared_widget/text_field.dart';

final _formKey = GlobalKey<FormState>();

Widget videoCallReportBottomSheet(BuildContext context, String appointmentId) {
  VideoCallBloc videoCallBloc = context.read<VideoCallBloc>();
  return BlocListener<VideoCallBloc, VideoCallState>(
    listener: (context, state) {
      print('the state in the report bottom sheet: $state');
      if (state is SessionCompletedFromOneSideDoneState ||
          state is VideoCallErrorState ||
          state is VideoCallReportingErrorState) {
        Get.back();
      } else if (state is ReportingVideoCallCompletedState) {
        Get.back();
        videoCallBloc.videoCallReportDescriptionController.clear();
      }
    },
    child: Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(20),
        height: Get.size.height * .6,
        decoration: const BoxDecoration(
          color: Color(0xff14181b),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              descriptionForUser(),
              customTextField(
                  validator: (value) {
                    if (value == null) {
                      return "This field can't be empty".tr;
                    } else if (value.isEmpty) {
                      return "This field can't be empty ".tr;
                    } else if (value.length < 6) {
                      return "You must enter more detailed information".tr;
                    }
                    return null;
                  },
                  context: context,
                  controller: context
                      .read<VideoCallBloc>()
                      .videoCallReportDescriptionController,
                  label: 'What did the patient do wrong?'),
              const SizedBox(height: 20),
              reportButtons(context, appointmentId),
            ],
          ),
        ),
      ),
    ),
  );
}

Row reportButtons(BuildContext context, String appointmentId) {
  VideoCallBloc videoCallBloc = context.read<VideoCallBloc>();
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      BlocBuilder<VideoCallBloc, VideoCallState>(
        builder: (context, state) {
          bool isLoading = state is ReportingVideoCallLoadingtState;
          return isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.blue,
                ))
              : ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blue),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Uint8List? pic =
                          await videoCallBloc.takeScreenshotAndReturnImage(
                              videoCallBloc.screenshotController);
                      if (pic != null) {
                        if (!isLoading) {
                          videoCallBloc.add(ReportVideoCallEvent(
                              appointmentId: appointmentId, pic: pic));
                        }
                      }
                    }
                  },
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white))
                      : Text(
                          'Yes'.tr,
                          style: const TextStyle(color: Colors.white),
                        ),
                );
        },
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.red),
        ),
        onPressed: () {
          Navigator.pop(context); // Close the bottom sheet
        },
        child: Text(
          'No'.tr,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ],
  );
}

Column descriptionForUser() {
  return Column(
    children: [
      Text(
        'Message Regarding Reporting During Video Calls'.tr,
        style: const TextStyle(color: Colors.white),
      ),
      const SizedBox(height: 16),
      Text(
        'We want to clarify when you should use the reporting feature during video calls:'
            .tr,
        style: const TextStyle(color: Colors.white),
      ),
      const SizedBox(height: 16),
      Text(
        '• Leaving the Call Without Agreement: If the other person ends the call without mutual agreement, you can report this behavior.'
            .tr,
        style: const TextStyle(color: Colors.white),
      ),
      const SizedBox(height: 8),
      Text(
        '• Inappropriate Behavior: If the other person engages in any improper or inappropriate actions during the call, you have the option to report them.'
            .tr,
        style: const TextStyle(color: Colors.white),
      ),
      const SizedBox(height: 16),
      Text(
        'Your reports help us maintain a safe and respectful environment for everyone.'
            .tr,
        style: const TextStyle(color: Colors.white),
      ),
      const SizedBox(height: 20),
    ],
  );
}
