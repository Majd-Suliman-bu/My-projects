// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker_app/constant/text_style.dart';
import 'package:worker_app/view/widget/snak_bar_for_errors.dart';

import '../../constant/server_const.dart';
import '../../constant/sizes.dart';
import '../../constant/status_request.dart';
import '../../constant/theme.dart';
import '../../data/Models/drink_model.dart';
import '../../general_controller/statuse_request_controller.dart';
import '../../main.dart';
import '../screens/bar/bar_page_service.dart';
import '../screens/cart/cart_page.dart';
import 'no_internet_page.dart';

// ignore: must_be_immutable
class DrinkCard extends StatelessWidget {
  DrinkModel drink;
  int id;
  Function()? onPressed;
  DrinkCard({super.key, required this.id, required this.drink, this.onPressed});
  @override
  Widget build(BuildContext context) {
    DrinkCardController controller = Get.put(
      DrinkCardController(),
    );
    Sizes size = Sizes(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Get.isDarkMode ? skinColorWhite! : backGroundDarkColor),
            color: Get.isDarkMode
                ? darkWoodBrownColor.withOpacity(0.9)
                : woodBrownColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(size.buttonRadius)),
        width: 100, //size.drinkCardWidth,
        height: 220,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.buttonRadius),
                    topRight: Radius.circular(size.buttonRadius),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: drink.image == ''
                            ? Image.asset(
                                'assets/images/medium page background image.jpg',
                                fit: BoxFit.fill,
                              )
                            : Image.network(
                                "${ServerConstApis.loadImages}${drink.image}",
                                fit: BoxFit.fill, errorBuilder: (context, Exception, StackTrace) {
                      return Image.asset('assets/images/The project icon.jpg',
                          fit: BoxFit.fill);
                    },
                              ),
                      ),
                      Positioned.fill(
                        child: Container(
                          color: backGroundDarkColor.withOpacity(0.2),
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 6,
                          ),
                          addRemoveButton('add', controller),
                          const Spacer(),
                          Obx(() => Text(
                                controller.numberOfDrinks[id].value.toString(),
                                style: TextStyle(
                                  color: skinColorWhite,
                                ),
                              )),
                          const Spacer(),
                          addRemoveButton('remove', controller),
                          const SizedBox(
                            width: 6,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: AutoSizeText(
                  drink.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: generalTextStyle(17),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              AutoSizeText(
                '${drink.price} S.P',
                style: generalTextStyle(15),
              ),
            ]),
      ),
    );
  }

  Widget addRemoveButton(
      String addOrRemove, DrinkCardController drinkCardController) {
    return SizedBox(
      width: 60,
      child: MaterialButton(
        onPressed: () {
          addOrRemove == 'add'
              ? drinkCardController.increaseTheNumberOfDrinks(id, drink)
              : drinkCardController.decreaseTheNumberOfDrinks(id, drink);
          //  add one from this drink or remove one of the drink
        },
        child: Icon(
          addOrRemove == 'add' ? Icons.add : Icons.remove,
          color: skinColorWhite,
        ),
        // ),
      ),
    );
  }
}

class DrinkCardController extends GetxController
    implements StatuseRequestController {
  List<RxInt> numberOfDrinks = <RxInt>[].obs;
  BarPageService service = BarPageService();
  List<DrinkModel> finalListData = [];
  @override
  StatuseRequest? statuseRequest = (StatuseRequest.init);
  @override
  void onInit() async {
    statuseRequest = await checkIfTheInternetIsConectedBeforGoingToThePage();
    finalListData = await sendingARequestAndHandlingData();

    super.onInit();
  }

  Future<List<DrinkModel>> sendingARequestAndHandlingData() async {
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
        await service.getDrinks(token);

    return response.fold((l) => l, (r) => r);
  }

  handlingData(response) {
    if (response is StatuseRequest) {
      return response;
    } else {
      return StatuseRequest.success;
    }
  }

  Future<List<DrinkModel>> whenGetDataSuccess(response) async {
    List responsedata = response['data'];
    for (int i = 0; i < responsedata.length; i++) {
      finalListData.add(DrinkModel.fromMap(responsedata[i]));
    }
    for (var i = 0; i < finalListData.length; i++) {
      numberOfDrinks.add(0.obs);
    }

    update();
    return finalListData;
  }

  MakeOrder order = MakeOrder();
  void increaseTheNumberOfDrinks(int id, DrinkModel drink) {
    numberOfDrinks[id].value++;
    if (ifAddForTheFirstTime(drink)) {
      order.drinksWithAmount.add(DrinkAmount(drink: drink, amount: 1));
    } else {
      for (var element in order.drinksWithAmount) {
        if (element.drink == drink) {
          element.amount++;
        }
      }
    }
  }

  bool ifAddForTheFirstTime(DrinkModel drink) {
    for (var element in order.drinksWithAmount) {
      if (element.drink.name == drink.name) {
        return false;
      }
    }
    return true;
  }

  void decreaseTheNumberOfDrinks(int id, DrinkModel drink) {
    for (var element in order.drinksWithAmount) {
      if (element.drink == drink) {
        if (element.amount > 0) {
          numberOfDrinks[id].value--;

          element.amount--;
          if (element.amount == 0) {
            order.drinksWithAmount.remove(element);
          }
          break;
        }
      }
    }
  }

  void makeTheNumberofDriknsEqualsZero() {
    for (var element in numberOfDrinks) {
      element.value = 0;
    }
  }

  void addNewElement() {
    numberOfDrinks.add(0.obs);
  }
}
