import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constant/status_request.dart';
import '../../../general_controller/statuse_request_controller.dart';
import '../../../main.dart';
import '../../widget/snak_bar_for_errors.dart';
import 'add_new_drink_service.dart';

class AddNewDrinkController extends GetxController
    implements StatuseRequestController {
  bool imageExcist = false;
  String selctFile = '';
  StatuseRequest? statuseRequest = StatuseRequest.init;
  late GlobalKey<FormState> formstate;
  AddDrinkService service = AddDrinkService();
  late String name;
  late String price;
  late String totalcost;
  late String aviableAmount;
  late String description;
  @override
  void onInit() {
    name = '';
    price = '';
    totalcost = '';
    aviableAmount = '';
    description = '';
    formstate = GlobalKey<FormState>();
    super.onInit();
  }

  // Future<Object> compressImage(File file) async {
  //   final XFile? result = await FlutterImageCompress.compressAndGetFile(
  //     file.absolute.path,
  //     file.absolute.path,
  //     quality: 70, // Adjust the quality as per your requirements
  //   );

  //   return result ?? file;
  // }

  late File image;
  final picker = ImagePicker();
  late Uint8List imageInBytes;
  Future<void> pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    // FilePickerResult? fileResult =
    // await FilePicker.platform.pickFiles(allowMultiple: true);
    if (pickedImage != null) {
      image = File(pickedImage.path);
      imageInBytes = await pickedImage.readAsBytes();
      // selectedImageInBytes = pickedFile.files.first.bytes!;
      imageExcist = true;
      update();
    }
  }

  onPressDone() async {
    FormState? formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();
      statuseRequest = StatuseRequest.loading;
      update();

      dynamic response =
          await addData(); // check if the return data is statuseRequest or real data
      statuseRequest = handlingData(response); //return the statuseResponse
      if (statuseRequest == StatuseRequest.success) {
        whenAddSuccess(response);
      } else if (statuseRequest == StatuseRequest.authfailuer) {
        snackBarForErrors("Auth error", "Please login again");
        Get.offAllNamed('LoginPage');
      } else if (statuseRequest == StatuseRequest.validationfailuer) {
        snackBarForErrors("Inputs wrong", "Please theck your inputs");
      } else {
        snackBarForErrors("Server error", "Please try again later");
      }
    }
    update();
  }

  addData() async {
    String token = await prefService.readString('token');

    Map<String, String> data = {
      'cost': totalcost,
      'title': name,
      'description': description,
      'quantity': aviableAmount,
      'price': price,
    };
    Either<StatuseRequest, Map<dynamic, dynamic>> response = await service
        .addDrink(data, imageInBytes, image.path.split('/').last, token);
    return response.fold((l) => l, (r) => r);
  }

  handlingData(response) {
    if (response is StatuseRequest) {
      return response;
    } else {
      return StatuseRequest.success;
    }
  }

  whenAddSuccess(response) async {
    imageExcist = false;

    Get.offAllNamed('/StockPage');
    update();
  }

  DateTime? selectedDate;
  RxBool isSelectedDateIsNull = true.obs;
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(DateTime.now().year + 3),
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }
    isSelectedDateIsNull.value = selectedDate == null;
    update();
  }
}
