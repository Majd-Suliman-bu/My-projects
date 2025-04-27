import 'package:get/get.dart';
import 'package:worker_app/view/screens/bar/bar_page_controller.dart';
import 'package:worker_app/view/widget/drink_card.dart';

import '../orders/orders_contrller.dart';

class BarPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BarPageController());
    Get.lazyPut(() => OrderController());
    Get.put(DrinkCardController());
  }
}
