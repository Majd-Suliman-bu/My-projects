import 'package:get/get.dart';
import 'package:worker_app/data/Models/door_model.dart';
import 'package:worker_app/data/Models/drink_model.dart';
import 'package:worker_app/view/screens/door/door_controller.dart';
import 'package:worker_app/view/widget/drink_card.dart';

class GeneralSearchController extends GetxController {
  DrinkCardController drinkCardController = Get.find();
  DoorController doorController = Get.find();
  List<DrinkModel> drinkSearchedList = [];
  List<ReservationResponse> finalSearchListData = [];
  @override
  void onInit() {
    drinkSearchedList = drinkCardController.finalListData;
    drinkSearchedListLength.value = drinkCardController.finalListData.length;
    customerSearchedListLength.value =doorController.finalListDataCome.length + doorController.finalListDataNotCome.length;

    finalSearchListData =
        doorController.finalListDataCome + doorController.finalListDataNotCome;
    super.onInit();
  }

  RxInt drinkSearchedListLength = 0.obs;
  RxInt customerSearchedListLength = 0.obs;
  void drinkSearch(String drinkSearhedName) {
    if (drinkSearchedList.isEmpty) {
      drinkSearchedList = drinkCardController.finalListData;
    }

    drinkSearchedList = drinkCardController.finalListData
        .where((character) => character.name
            .toLowerCase()
            .startsWith(drinkSearhedName.toLowerCase()))
        .toList();
  }

  void customerSearch(String customerName2) {
    finalSearchListData = doorController.finalListDataCome
        .where((character) => character.customerName
            .toLowerCase()
            .startsWith(customerName2.toLowerCase()))
        .toList()+doorController.finalListDataNotCome
        .where((character) => character.customerName
            .toLowerCase()
            .startsWith(customerName2.toLowerCase()))
        .toList();
print('finalSearchListData.length');
        print(finalSearchListData.length);
        print('doorController.finalListDataCome.length');
        print(doorController.finalListDataCome.length);
        
  }
}
