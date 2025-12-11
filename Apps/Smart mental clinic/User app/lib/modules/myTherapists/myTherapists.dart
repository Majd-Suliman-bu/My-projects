import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/bloc/chat_bloc.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/repo/chat_repo.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/view/screens/chat_init_page.dart';
import 'package:smart_medical_clinic/modules/profile/custom_refresh_indicator.dart';
import 'package:smart_medical_clinic/shared_widget/app_injection.dart';

import '../../models/therapists.dart';
import 'myTherapists_controller.dart';

class MyTherapists extends StatelessWidget {
  final MyTherapistsController controller = Get.find<MyTherapistsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.therapists.isEmpty) {
          return customRefreshIndicator(
            () async {
              controller.therapists.value = [];
              controller.onInit();
            },
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                      child: Text(
                        "No therapists available".tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return customRefreshIndicator(
            () async {
              controller.therapists.value = [];
              controller.onInit();
            },
            ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.therapists.length,
              itemBuilder: (context, index) {
                Datum therapist = controller.therapists[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        therapist.specialistPhoto,
                      ),
                      radius: 30, // Adjust the size as needed
                    ),
                    title: Text(
                      therapist.specialistName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      therapist.roleId == 1 ? "Doctor".tr : "Therapist".tr,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Get.to(
                              () => ChatPageWrapper(
                                channelName: therapist.channelName,
                                myId: therapist.patientId,
                                therapistID: therapist.specId,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(),
                          child: Text(
                            "Chat".tr,
                          ),
                        ),
                        if (therapist.roleId == 2)
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              _showUnassignDialog(context, therapist);
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }

  void _showUnassignDialog(BuildContext context, Datum therapist) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Unassign Therapist".tr),
          content: Text("Are you sure you want to unassign the therapist?".tr),
          actions: [
            TextButton(
              child: Text("No".tr),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes".tr),
              onPressed: () async {
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                // Call deleteTherapist and wait for the response
                await controller.deleteTherapist(therapist.specId);

                // Close the loading indicator and the confirmation dialog
                Navigator.of(context).pop(); // Close the loading indicator
                Navigator.of(context).pop(); // Close the confirmation dialog
              },
            ),
          ],
        );
      },
    );
  }
}

class ChatPageWrapper extends StatelessWidget {
  final String channelName;
  final int myId;
  final int therapistID;

  const ChatPageWrapper(
      {Key? key,
      required this.channelName,
      required this.myId,
      required this.therapistID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access ChatBloc from the context and set the channelName
    final chatBloc = context.read<ChatBloc>();
    chatBloc.channelName = channelName;
    chatBloc.userID = myId;

    return BlocProvider(
      create: (context) =>
          ChatBloc(chatRepositoryImp: ChatRepositoryImp(chatDataSource: sl())),
      child: ChatInitPage(therapistID: therapistID),
    );
  }
}
