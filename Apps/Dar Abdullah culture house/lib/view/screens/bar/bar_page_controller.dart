import 'package:get/get.dart';

class BarPageController extends GetxController {
  late int eventId ;
  @override
  void onInit() {
    eventId=Get.arguments;
    super.onInit();
  }
  RxInt page = 0.obs;
  void changePage(int index) {
    page.value = index;
  }
}
