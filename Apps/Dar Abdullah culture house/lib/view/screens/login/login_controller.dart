
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/status_request.dart';
import '../../../constant/theme.dart';
import '../../../general_controller/statuse_request_controller.dart';
import '../../../main.dart';
import 'login_service.dart';

class LoginController extends GetxController
    implements StatuseRequestController {
  late String password;
  late String email;
  @override
  StatuseRequest? statuseRequest = StatuseRequest.init;
  late RxBool passwordSecure = true.obs;
  LoginService service = LoginService();
  late GlobalKey<FormState> formstate;

  @override
  void onInit() async {
    password = '';
    email = '';
    formstate = GlobalKey<FormState>();
    //statuseRequest = await checkIfTheInternetIsConectedBeforGoingToThePage();
    super.onInit();
  }

  void changePasswordSecure() {
    passwordSecure.value = !passwordSecure.value;
  }

  void onpresslogin() async {

    FormState? formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();
      statuseRequest = StatuseRequest.loading;
      update();
      dynamic response =
          await logindata(); // check if the return data is statuseRequest or real data
      statuseRequest = handlingData(response); //return the statuseResponse
      if (statuseRequest == StatuseRequest.success) {
        whenLoginSuccess(response);
      } else if (statuseRequest == StatuseRequest.authfailuer) {
        snackBarForErrors();
      } else if (statuseRequest == StatuseRequest.validationfailuer) {
        snackBarForErrors();
      } else {
        snackBarForErrors();
      }
    }
    update();
  }

  SnackbarController snackBarForErrors() {
    return Get.snackbar(
        "Incorrect email or password".tr, ///// adding for translate  done
        "Try entering your data again".tr, //// adding for translate  done
        snackPosition: SnackPosition.TOP,
        colorText: Get.isDarkMode ? skinColorWhite : backGroundDarkColor,
        backgroundColor: Get.isDarkMode ? backGroundDarkColor : skinColorWhite,
        duration: const Duration(seconds: 5));
  }

  logindata() async {
    Map<String, String> data = {
      "email": email,
      "password": password
    };
    Either<StatuseRequest, Map<dynamic, dynamic>> response =
        await service.login(data);

    return response.fold((l) => l, (r) => r);
  }

  handlingData(response) {
    if (response is StatuseRequest) {
      return response;
    } else {
      return StatuseRequest.success;
    }
  }

  whenLoginSuccess(response) async {
    await prefService.createString('token', response['data']['token']); // storing token
    await prefService.createString('id', response['data']['worker_id'].toString()); // storing token
    Get.offNamed('/EventPage');
    update();
  }
}
