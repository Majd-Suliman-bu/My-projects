import 'package:get/get.dart';
import '../modules/downloads.dart/downloads_controller.dart';

class DownloadsBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<DownloadsController>(DownloadsController());
  }
}
