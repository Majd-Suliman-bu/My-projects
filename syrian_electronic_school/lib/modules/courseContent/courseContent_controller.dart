import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syrian_electronic_school/modules/courseContent/courseContent_service.dart';

import '../../models/Course.dart';

class CourseContentController extends GetxController {
  CourseContentService service = CourseContentService();
  late Data data;
  var isloading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() async {
    data = await service.showCourse();
    print("---------------------------------------------------------------");
    print("title is ::::::: ${data.title} ");
    isloading(false);
    super.onReady();
  }
}
