import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../../../constant/server_const.dart';
import '../../../constant/status_request.dart';
import '../../../data/checkInternet/check_internet.dart';
import 'package:http/http.dart' as http;

import '../../widget/snak_bar_for_errors.dart';
import '../door/door_controller.dart';
import 'orders_contrller.dart';

class OrdersService {
   Future<bool> checkingOreders() async {
    var _client = http.Client();
    var request = new http.Request(
        "GET", Uri.parse('${ServerConstApis.baseAPI}notificationsForOrders'));
    request.headers["Cache-Control"] = "no-cache";
    request.headers["Accept"] = "text/event-stream";

    final response = await _client.send(request); // Await the response

    if (response.statusCode == 200) {
      await response.stream.listen((data) async{
        String d = utf8.decode(data);
        d = d.trim();
        print("Received data: $d");
       print(d);
        if (d != 'data: init') {
         if(d =='data: new Order'){
          OrderController s=Get.find();
          s.finalListData=[];
          print(s.finalListData.length);
          s.sendingARequestAndHandlingData();
          s.update();
          snackBarForErrors("New order added", "Please serve it");
         }else{
          DoorController doorController=Get.find();
          doorController.finalListDataCome=[];
          doorController.finalListDataNotCome=[];
          await doorController.sendingARequestAndHandlingData();
          doorController.update();
          snackBarForErrors("New reservation added", "Please review it");
         
         }
           }
        // Here, you can parse the data as needed and handle the event
      }).asFuture(); // Await the stream subscription to complete
    } else {
      print("Received unexpected status code: ${response.statusCode}");
    }
    return true;
  }

  Future<Either<StatuseRequest, Map>> denyOrder(String token,Map<String, String> data) async {
    //Either for return two data type in the same time
    try {
      if (await checkInternet()) {
        Uri url = Uri.parse(ServerConstApis.denyOrder);
        http.Response response = await http.post(
          url,
          body: data,
          headers: {"Access-Control-Allow-Origin": "*","x-access-token": token},
        );
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          final responsebody = jsonDecode(response.body);
          return Right(responsebody);
        } else if (response.statusCode == 400) {
          return const Left(StatuseRequest.validationfailuer);
        } else if (response.statusCode == 401) {
          return const Left(StatuseRequest.authfailuer);
        } else {
          return const Left(StatuseRequest.serverfailure);
        }
      } else {
        return const Left(StatuseRequest
            .offlinefailure); //left return the left data type =>StatuseRequest
      }
    } catch (e) {
      print(e);
      return const Left(StatuseRequest.serverfailure);
    }
  }

  Future<Either<StatuseRequest, Map>> approveOrder(String token,Map<String, String> data) async {
    //Either for return two data type in the same time
    try {
      if (await checkInternet()) {
        Uri url = Uri.parse(ServerConstApis.approveOrder);
        http.Response response = await http.post(
          url,
          body: data,
          headers: {"Access-Control-Allow-Origin": "*","x-access-token": token},
        );
        print("/////////////////////////////////////");
        print(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          final responsebody = jsonDecode(response.body);
          return Right(responsebody);
        } else if (response.statusCode == 400) {
          return const Left(StatuseRequest.validationfailuer);
        } else if (response.statusCode == 401) {
          return const Left(StatuseRequest.authfailuer);
        } else {
          return const Left(StatuseRequest.serverfailure);
        }
      } else {
        return const Left(StatuseRequest
            .offlinefailure); //left return the left data type =>StatuseRequest
      }
    } catch (e) {
      print(e);
      return const Left(StatuseRequest.serverfailure);
    }
  }

  Future<Either<StatuseRequest, Map>> getOrders(String token) async {
    //Either for return two data type in the same time
    try {
      if (await checkInternet()) {
        print("start");
        Uri url = Uri.parse(ServerConstApis.showOrders);
        Map<String, String> headers = {
          // "Access-Control-Allow-Origin": "*",
          "x-access-token": token
        };

        var response = await http.get(url, headers: headers);
print(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          final responsebody = jsonDecode(response.body);

          return Right(responsebody);
        } else if (response.statusCode == 401) {
          return const Left(StatuseRequest.authfailuer);
        } else {
          return const Left(StatuseRequest.serverfailure);
        }
      } else {
        return const Left(StatuseRequest
            .offlinefailure); //left return the left data type =>StatuseRequest
      }
    } catch (e) {
      return const Left(StatuseRequest.offlinefailure);
    }
  }
}
