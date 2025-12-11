import 'package:get/get.dart';
import '../modules/reservations/reservations_controller.dart';

class ReservationsBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ReservationsController>(ReservationsController());
  }
}
