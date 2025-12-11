import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../../../constant/status_request.dart';

import '../../../data/Models/event_model.dart';
import '../../../general_controller/statuse_request_controller.dart';
import '../../../main.dart';
import '../../widget/no_internet_page.dart';
import '../../widget/snak_bar_for_errors.dart';
import 'event_service.dart';

class EventPageController extends GetxController
    implements StatuseRequestController {
  List<EventModel> finalListData = [];
  EventService service = EventService();
  @override
  StatuseRequest? statuseRequest = (StatuseRequest.init);
  @override
  void onInit() async {
    // statuseRequest = await checkIfTheInternetIsConectedBeforGoingToThePage();
    finalListData = await sendingARequestAndHandlingData();
    statuseRequest = await checkIfTheInternetIsConectedBeforGoingToThePage();
service.sse();
await service.checkingConfirmation();
  
    super.onInit();
  }

  Future<List<EventModel>> sendingARequestAndHandlingData() async {
    // print("drrrrrrrrrrrrrrr");
    statuseRequest = StatuseRequest.loading;
    update();
    dynamic response =
        await getdata(); // check if the return data is statuseRequest or real data
    statuseRequest = handlingData(response); //return the statuseResponse
    if (statuseRequest == StatuseRequest.success) {
      return whenGetDataSuccess(response);
    } else if (statuseRequest == StatuseRequest.authfailuer) {
      snackBarForErrors("Auth error", "Please login again");
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
        await service.getEvents(token);

    return response.fold((l) => l, (r) => r);
  }

  handlingData(response) {
    if (response is StatuseRequest) {
      return response;
    } else {
      return StatuseRequest.success;
    }
  }

  Future<List<EventModel>> whenGetDataSuccess(response) async {
    List responsedata = response['data']['upComing'];
    List responsedata2 = response['data']['now'];
    print(responsedata);
    finalListData=[];
    for (var i = 0; i < responsedata2.length; i++) {
      finalListData.add(EventModel.fromMap(responsedata2[i]));
    
    }
    for (int i = 0; i < responsedata.length; i++) {
  
      finalListData.add(EventModel.fromMap(responsedata[i]));
    }
 
    update();
    return finalListData;
  }
}
