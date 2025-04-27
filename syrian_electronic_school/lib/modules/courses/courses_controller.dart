import 'package:get/get.dart';
import '../../config/user_info.dart';
import './courses_service.dart';


import '../../native_service/secure_storage.dart';

class CoursesController extends GetxController {
  Coursesservice service = Coursesservice();

  var isloading = true.obs;


  void onReady() async {

    isloading(false);

    super.onReady();
  }
  @override
  void onInit() {

    super.onInit();
  }


}
