import 'package:get/get.dart';
import '../../config/user_info.dart';
import './setting_service.dart';


import '../../native_service/secure_storage.dart';

class SettingController extends GetxController {
  Settingservice service = Settingservice();

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
