import 'package:get/get.dart';
import '../modules/aboutUs/aboutUs_controller.dart';

class AboutUsBinding implements Bindings{
  @override
  void dependencies() {

    Get.put<AboutUsController> (AboutUsController());
  }

}