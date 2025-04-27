import 'package:get/get.dart';
import '../modules/courses/courses_controller.dart';

class CoursesBinding implements Bindings{
  @override
  void dependencies() {

    Get.put<CoursesController> (CoursesController());
  }

}