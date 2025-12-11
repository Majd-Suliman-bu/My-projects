import 'package:get/get.dart';
import 'package:syrian_electronic_school/models/Course.dart';
import '../modules/courseVideo/courseVideo_Controller.dart';

class CourseVideoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseVideoController>(() => CourseVideoController());
  }
}
