import 'package:get/get.dart';
import './mySubscriptions_service.dart';
import '../../models/mySubscriptions.dart';

class MySubscriptionsController extends GetxController {

  var isloading = true.obs;
  late List<MyCourses> myCourses;
  MySubscriptionsService service = MySubscriptionsService();

  void onReady() async {
    getAllSubscriptions();

    super.onReady();
  }

  void getAllSubscriptions() async {
    myCourses = await service.getAllSubscriptions();
    isloading(false);
  }


}