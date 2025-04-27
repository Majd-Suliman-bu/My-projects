import 'package:get/get.dart';

import '../modules/tabView/tabView_controller.dart';

class TabViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<TabViewController>(TabViewController());
  }
}
