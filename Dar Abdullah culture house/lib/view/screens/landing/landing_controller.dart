import 'package:get/get.dart';

import '../../../main.dart';

class OnBoardController extends GetxController {
  final List<Map<String, String>> pageDetails = [
    {
      "title": "welcome to our app",
      "image": "assets/images/medium page background image.jpg"
    },
    {
      "title": "manage all the house with this system",
      "image": "assets/images/medium page background image.jpg"
    },
    {
      "title": "other thing need to rewrite",
      "image": "assets/images/medium page background image.jpg"
    },
    {
      "title": "other thing need to rewrite",
      "image": "assets/images/medium page background image.jpg"
    },
  ];

  RxInt pageIndex = 1.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void setPageIndex(int index) {
    pageIndex.value = index;
  }

  void onPress() async {
    if(! await prefService.isContainKey('enentI')){
    await prefService.createString('enentI',0.toString());
    }
    if (await prefService.isContainKey('token')) {
      
      Get.offAllNamed('/EventPage');
      
     
      } else {
      
      Get.offAllNamed('/LoginPage');
    
    }
  }
}
