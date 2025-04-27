import 'package:get/get.dart';
import 'package:worker_app/view/screens/add_new_drink_stock/add_new_drink_controller.dart';
import 'package:worker_app/view/screens/edite_drink_on_stock/edite_drink_on_stock_controller.dart';
import 'package:worker_app/view/screens/stock/stock_controller.dart';

class StockBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(StockController());
    Get.lazyPut(()=>AddNewDrinkController());
    Get.lazyPut(()=>EditeDrinkOnStockController());
  }
}
