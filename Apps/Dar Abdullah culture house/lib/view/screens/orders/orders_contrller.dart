import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../../../constant/status_request.dart';

import '../../../data/Models/costumer_order.dart';
import '../../../general_controller/statuse_request_controller.dart';
import '../../../main.dart';
import '../../widget/no_internet_page.dart';
import '../../widget/snak_bar_for_errors.dart';
import 'orders_service.dart';

class OrderController extends GetxController
    implements StatuseRequestController {
  List<CustomerOrderModel> finalListData = [];
  OrdersService service = OrdersService();
  @override
  StatuseRequest? statuseRequest = (StatuseRequest.init);
  @override
  void onInit() async {
    // statuseRequest = await checkIfTheInternetIsConectedBeforGoingToThePage();
    finalListData = await sendingARequestAndHandlingData();
    statuseRequest = await checkIfTheInternetIsConectedBeforGoingToThePage();
service.checkingOreders();
    super.onInit();
  }

  Future<List<CustomerOrderModel>> sendingARequestAndHandlingData() async {
    // print("drrrrrrrrrrrrrrr");
    statuseRequest = StatuseRequest.loading;
    update();
    dynamic response =
        await getdata(); // check if the return data is statuseRequest or real data
    statuseRequest = handlingData(response); //return the statuseResponse
    if (statuseRequest == StatuseRequest.success) {
      return whenGetDataSuccess(response);
    } else if (statuseRequest == StatuseRequest.authfailuer) {
      snackBarForErrors("Auth error".tr, "Please login again".tr);
      Get.offAllNamed('LoginPage');
    } else {
      // when happen a mestake we handel it here
      [];
    }
    update();
    return [];
  }

  getdata() async {
    String token = await prefService.readString('token');

    Either<StatuseRequest, Map<dynamic, dynamic>> response =
        await service.getOrders(token);

    return response.fold((l) => l, (r) => r);
  }

  handlingData(response) {
    if (response is StatuseRequest) {
      return response;
    } else {
      return StatuseRequest.success;
    }
  }

  Future<List<CustomerOrderModel>> whenGetDataSuccess(response) async {
    List responsedata = response['data'];
    finalListData=[];
    for (int i = 0; i < responsedata.length; i++) {
      finalListData.add(CustomerOrderModel.fromMap(responsedata[i]));
    }
    print("lengthhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
    print(finalListData.length);
    update();
    return finalListData;
  }

  double calculatePriceFromOrder(int index) {
    double price = 0;
    for (int i = 0; i < finalListData[index].orderDrinks.length; i++) {
      price +=  finalListData[index].orderDrinks[i].drinkPrice *  finalListData[index].orderDrinks[i].quantity;
    }
   
    return price;
  }

  int calculateAmountForOneOrder(List<OrderDrink> orders) {
    int amount = 0;
    for (var i = 0; i < orders.length; i++) {
      amount += orders[i].quantity;
    }
    return amount;
  }

  onPressApproveToOrder(int id, int idFinal) async {
    String token = await prefService.readString('token');
    Map<String, String> data = {"order_id": id.toString()};
    Either<StatuseRequest, Map<dynamic, dynamic>> response =
        await service.approveOrder(token, data);

    statuseRequest=handlingData(response);
if (statuseRequest == StatuseRequest.success) {
      finalListData.removeAt(idFinal);
      update();
    } 
  }

  onPressDenyToOrder(int id,int idFinal) async {
    String token = await prefService.readString('token');
    Map<String, String> data = {"order_id": id.toString()};
    Either<StatuseRequest, Map<dynamic, dynamic>> response =
        await service.denyOrder(token, data);
statuseRequest=handlingData(response);
if (statuseRequest == StatuseRequest.success) {
      finalListData.removeAt(idFinal);
      update();
    } 
    // return response.fold((l) => l, (r) => r);
  }
}
