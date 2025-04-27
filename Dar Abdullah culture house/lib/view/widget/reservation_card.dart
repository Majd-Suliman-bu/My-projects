import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker_app/constant/text_style.dart';
import 'package:worker_app/constant/theme.dart';
import '../../data/Models/door_model.dart';
import '../screens/door/door_controller.dart';

// ignore: must_be_immutable
class ReservationCard extends StatelessWidget {
  final ReservationResponse reservation;
  final int index;
  final DoorController controller = Get.find();
  ReservationCard({super.key, required this.reservation, required this.index});

  @override
  Widget build(BuildContext context) {
    // final ReservationCardController controller = Get.put(
    //   ReservationCardController(),
    //   tag: reservation.hashCode.toString(),
    // );

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(right: 5, top: 2, bottom: 2),
          child: ListTile(
            leading: SizedBox(
              height: 40,
              width: 40,
              child: TextButton(
                onPressed: () {
                   controller.toggleTrueSign(index,reservation.numberOfPlaces,reservation.attendanceNumber!);
                },
                child: Obx(() => Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: Get.isDarkMode
                              ? Colors.grey[400]!
                              : const Color.fromARGB(255, 54, 54, 54)),
                    ),
                    child: controller.showTrueSign[index].value
                        ? Center(
                            child: Icon(Icons.check,
                                color: Get.isDarkMode
                                    ? darkPrimaryColor
                                    : primaryColor),
                          )
                        : null)),
              ),
            ),
            title: Text(
              "${'Name'.tr}: ${reservation.customerName}",
              style: generalTextStyle(null),
            ),
            subtitle: Text(
              "${'Number of people'.tr}: ${reservation.numberOfPlaces}",
              style: generalTextStyle(null),
            ),
            trailing: SizedBox(
              width: 142,
              child: Row(
                children: [
                  const SizedBox(
                    width: 6,
                  ),
                  addRemoveButton('add', controller, index,reservation),
                  //  Obx(() {
                    // controller.myOnStart(reservation);
                    Text(
                      controller.numberOfPepole[index]
                          .toString(),
                      style: generalTextStyle(null),
                    ),
                  //  }),
                  addRemoveButton('remove', controller, index,reservation),
                  const SizedBox(
                    width: 6,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

Widget addRemoveButton(
  String addOrRemove,
  DoorController reservationController,
  int reservationId,
  ReservationResponse model
) {
  return SizedBox(
    width: 50,
    child: MaterialButton(
      onPressed: () {
        addOrRemove == 'add'
            ? reservationController.increaseTheNumberOfPeople(reservationId,model.numberOfPlaces)
            : reservationController.decreaseTheNumberOfPeople(reservationId,model.numberOfPlaces);
      },
      child: Icon(
        addOrRemove == 'add' ? Icons.add : Icons.remove,
        color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor,
      ),
      // ),
    ),
  );
}

// class ReservationCardController extends GetxController {
//   RxBool showTrueSign = false.obs;

//   void toggleTrueSign() {
//     showTrueSign.toggle();
//   }

 
// }
