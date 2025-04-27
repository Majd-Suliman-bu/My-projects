import 'package:get/get.dart';
import '../modules/mySubscriptions/mySubscriptions_controller.dart';

class MySubscriptionsBinding implements Bindings{
  @override
  void dependencies() {

    Get.put<MySubscriptionsController> (MySubscriptionsController());
  }

}