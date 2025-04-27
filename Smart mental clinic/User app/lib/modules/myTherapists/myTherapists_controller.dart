import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_medical_clinic/shared_widget/custom_snack_bar.dart';
import '../../models/therapists.dart';
import 'myTherapists_service.dart';

class MyTherapistsController extends GetxController {
  var therapists = <Datum>[].obs;
  var isLoading = false.obs;
  MyTherapistsService service = MyTherapistsService();

  @override
  void onInit() {
    super.onInit();
    loadTherapists();
  }

  void loadTherapists() async {
    isLoading.value = true;
    Therapists? therapistsData = await service.getTherapists();
    if (therapistsData != null && therapistsData.success) {
      therapists.assignAll(therapistsData.data);
    } else {
      print('Failed to load therapists');
    }
    isLoading.value = false;
  }

  Future<void> deleteTherapist(int id) async {
    bool? state = await service.deleteTherapists(id);
    if (state == true) {
      customSnackBar(
        "Success".tr,
        "Therapist unassigned successfully".tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      onInit();
    } else {
      customSnackBar(
        "Failed to unassign therapist".tr,
        MyTherapistsService.error,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
