import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:smart_medical_clinic/shared_widget/custom_snack_bar.dart';

import '../../models/userProfile.dart';
import 'profile_service.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs; // Observable loading state
  final ProfileService _profileService = ProfileService();
  var userprofile = Rxn<UserProfile>();
  FlutterSecureStorage storage =
      FlutterSecureStorage(); // Secure storage instance

  @override
  void onInit() {
    super.onInit();

    fetchUserProfile();
  }

  void fetchUserProfile() async {
    isLoading.value = true;
    var result = await _profileService.getUserProfile();
    isLoading.value = false;
    if (result != null) {
      userprofile.value = result;
    } else {
      customSnackBar("Error".tr, "Failed to fetch user profile".tr);
    }
  }

  Future<bool> verifyCode(String code) async {
    isLoading.value = true;
    bool success = await _profileService.redeemCode(code);
    isLoading.value = false;
    if (success) {
      onInit();
      customSnackBar("Success".tr, "Code redeemed successfully".tr,
          backgroundColor: Colors.green, colorText: Colors.white);
      return true;
    } else {
      customSnackBar("Error".tr, ProfileService.error,
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }
}
