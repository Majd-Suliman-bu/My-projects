import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:smart_medical_clinic/modules/videoCall/bloc/video_call_bloc.dart';

Widget agreeToEndCallBottomSheet(BuildContext context, String appointmentId) {
  return BlocListener<VideoCallBloc, VideoCallState>(
    listener: (context, state) {
      if (state is SessionCompletedFromOneSideDoneState ||
          state is VideoCallErrorState) {
        Get.back();
      }
    },
    child: Container(
      padding: const EdgeInsets.all(20),
      height: Get.size.height * .27,
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
            Text(
                'Are you sure you want to agree to end this call? Once both parties agree, the session cannot be reported, and either party can leave the call at any time.'
                    .tr,
                style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BlocBuilder<VideoCallBloc, VideoCallState>(
                  builder: (context, state) {
                    bool isLoading = state is SessionCompletedLoadingState;
                    return isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.blue,
                          ))
                        : ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.blue),
                            ),
                            onPressed: () {
                              if (!isLoading) {
                                context.read<VideoCallBloc>().add(
                                    SendCompleteSessionEvent(
                                        appointmentId: appointmentId));
                              }
                            },
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white))
                                : Text(
                                    'Yes'.tr,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
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
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
