import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../../../constant/status_request.dart';

import '../../../data/Models/door_model.dart';
import '../../../general_controller/statuse_request_controller.dart';
import '../../../main.dart';
import '../../widget/no_internet_page.dart';
import '../../widget/snak_bar_for_errors.dart';
import 'door_service.dart';

class DoorController extends GetxController
    implements StatuseRequestController {
  List<ReservationResponse> finalListDataCome = [];
  List<ReservationResponse> finalListDataNotCome = [];
  DoorService service = DoorService();
  late int eventID;
  @override
  StatuseRequest? statuseRequest = (StatuseRequest.init);
  @override
  void onInit() async {
    // statuseRequest = await checkIfTheInternetIsConectedBeforGoingToThePage();
    await sendingARequestAndHandlingData();
    statuseRequest = await checkIfTheInternetIsConectedBeforGoingToThePage();
    eventID = 64;
    super.onInit();
  }

  Future<List<ReservationResponse>> sendingARequestAndHandlingData() async {
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
    Map<String, String> data = {"event_id": eventID.toString()};
    Either<StatuseRequest, Map<dynamic, dynamic>> response =
        await service.getDoorReservations(token, data);

    return response.fold((l) => l, (r) => r);
  }

  handlingData(response) {
    if (response is StatuseRequest) {
      return response;
    } else {
      return StatuseRequest.success;
    }
  }

  List<int> numberOfPepole = [];
  Future<List<ReservationResponse>> whenGetDataSuccess(response) async {
    List notComeData = response['data']['notCome'];
    List comeData = response['data']['hasCome'];
finalListDataCome=[];
finalListDataNotCome=[];
    for (int i = 0; i < notComeData.length; i++) {
      finalListDataNotCome.add(ReservationResponse.fromJson(notComeData[i]));
      numberOfPepole.add(finalListDataNotCome[i].attendanceNumber!);
      showTrueSign.add(false.obs);
    }

    for (int i = 0; i < comeData.length; i++) {
      // print(i);
      finalListDataCome.add(ReservationResponse.fromJson(comeData[i]));
      numberOfPepole.add(finalListDataCome[i].attendanceNumber!);
      showTrueSign.add(false.obs);
    }
    print(showTrueSign.length);
// print("${finalListData[0].beginDate.hour}:${finalListData[0].beginDate.minute}");
    update();
    return finalListDataCome;
  }

  List<ReservationResponse> reservationChanged = [];
  void increaseTheNumberOfPeople(int reservationID, int numberOfPlaces) {
    if (numberOfPepole[reservationID] < numberOfPlaces) {
      numberOfPepole[reservationID]++;
      if (numberOfPepole[reservationID] == numberOfPlaces) {
        showTrueSign[reservationID].value = true;
      }
      update();
    }
  }

  void decreaseTheNumberOfPeople(int reservationID, int numberOfPlaces) {
    if (numberOfPepole[reservationID] == numberOfPlaces) {
      showTrueSign[reservationID].value = false;
    }
    if (numberOfPepole[reservationID] > 0) {
      numberOfPepole[reservationID]--;
    }
    update();
  }

  List<RxBool> showTrueSign = [];

  void toggleTrueSign(
      int reservationID, int numberOfPlaces, int attendanceNumber) {
    if (showTrueSign[reservationID].value) {
      showTrueSign[reservationID].value = false;
      numberOfPepole[reservationID] = attendanceNumber;
      update();
    } else {
      numberOfPepole[reservationID] = numberOfPlaces;
      showTrueSign[reservationID].value = true;
      update();
    }
  }

  ///////  send

  onPressDone() async {
    // print("drrrrrrrrrrrrrrr");
    statuseRequest = StatuseRequest.loading;
    update();
    dynamic response =
        await sendData(); // check if the return data is statuseRequest or real data
    statuseRequest = handlingData(response); //return the statuseResponse
    if (statuseRequest == StatuseRequest.success) {
      return whenSendDataSuccess(response);
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

  sendData() async {
    String token = await prefService.readString('token');
    List<Map<String, String>> data = [];
    for (var i = 0; i < finalListDataNotCome.length; i++) {
      if (numberOfPepole[i] != finalListDataNotCome[i].attendanceNumber!) {
        data.add({
          "reservation_id": finalListDataNotCome[i].reservationId.toString(),
          "attendance_number": numberOfPepole[i].toString()
        });
      }
    }
    for (var i = 0; i < finalListDataCome.length; i++) {
      if (numberOfPepole[i + finalListDataNotCome.length] !=
          finalListDataCome[i].attendanceNumber!) {
        data.add({
          "reservation_id": finalListDataCome[i].reservationId.toString(),
          "attendance_number": numberOfPepole[i].toString()
        });
      }
    }
    var d;
    for (var i = 0; i < data.length; i++) {
      Either<StatuseRequest, Map<dynamic, dynamic>> response =
          await service.sendReservatoin(token, data[i]);
      d = response.fold((l) => l, (r) => r);
    }

    statuseRequest = handlingData(d); //return the statuseResponse
    if (statuseRequest == StatuseRequest.success) {
      return whenSendDataSuccess(d);
    }
  }

  whenSendDataSuccess(response) async {
    snackBarForErrors("Edit Done", "The reservations edited ");

    // sendingARequestAndHandlingData();
  }
}
