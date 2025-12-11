import 'package:get/get.dart';
import '../modules/localFiles/localFiles_controller.dart';

class LocalFilesBinding implements Bindings{
  @override
  void dependencies() {

    Get.put<LocalFilesController> (LocalFilesController());
  }

}