import 'package:get/get.dart';
import '../modules/courseContent/courseContent_controller.dart';

class CourseContentBinding implements Bindings{
  @override
  void dependencies() {

    Get.put<CourseContentController> (CourseContentController());
  }
}