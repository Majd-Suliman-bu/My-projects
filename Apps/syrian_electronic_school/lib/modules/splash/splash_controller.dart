import 'package:get/get.dart';
import 'package:syrian_electronic_school/config/user_info.dart';
import '../../native_service/secure_storage.dart';

class SplashController extends GetxController {
  late Securestorage _storage;
  @override
  Future<void> onInit() async {
    // TODO: implement onInit

    _storage = Securestorage();
    await checkToken();
    super.onInit();

  }
  Future<void>checkToken() async {
    String ? token = await _storage.read("Access Token");
    if(token != null){
      String ? tempclassID = await _storage.read("classID");
      UserInfo.classID= int.parse(tempclassID!);
      String ? tempclassName = await _storage.read("className");
      UserInfo.className= tempclassName!;
      UserInfo.user_name= (await _storage.read("User name"))!;
      UserInfo.user_email = (await _storage.read("email"))!;
      Get.offAllNamed("/Home");

    }else{
      Get.offNamed("/Landing");
    }


  }
}
