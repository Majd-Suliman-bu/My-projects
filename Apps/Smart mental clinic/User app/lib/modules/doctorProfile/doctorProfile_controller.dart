import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_medical_clinic/models/doctorProfile.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/helper-stuff/custom_snackbar.dart';
import 'package:smart_medical_clinic/shared_widget/custom_snack_bar.dart';
import 'doctorProfile_service.dart';

class DoctorProfileController extends GetxController {
  var doctorProfile = Rxn<DoctorProfile>();
  var isLoading = false.obs; // Observable for loading state
  final DoctorProfileService _doctorService = DoctorProfileService();

  @override
  void onInit() {
    super.onInit();
    fetchDoctorProfile();
  }

  void fetchDoctorProfile() async {
    isLoading.value = true; // Set loading to true before fetching data
    var result = await _doctorService.getDoctorProfile();

    if (result != null) {
      doctorProfile.value = result;
    }
    isLoading.value = false; // Set loading to false after fetching data
  }

  Future<bool> RequestAppointment(int id) async {
    isLoading.value = true;
    try {
      bool result = await _doctorService.RequestAppointment(id);
      isLoading.value = false;

      if (result) {
        customSnackBar(
            "Request success".tr, "Your appointment request has been sent.".tr,
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        customSnackBar("Request failed".tr, DoctorProfileService.error,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
      return result;
    } catch (e) {
      print('error in request appointment: $e');
      return false;
    }
  }
}
