import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:smart_medical_clinic/modules/profile/custom_refresh_indicator.dart';
import 'package:smart_medical_clinic/modules/videoCall/bloc/video_call_bloc.dart';
import 'package:smart_medical_clinic/shared_widget/custom_snack_bar.dart';
import '../../models/reservation.dart';
import 'reservations_controller.dart';

class Reservations extends StatelessWidget {
  final ReservationsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservations'.tr),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // Adjust the height as needed
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => controller.setFilter('confirmed'),
                  child: Text('Confirmed'.tr,
                      style:
                          TextStyle(color: Color.fromARGB(255, 106, 168, 219))),
                ),
                TextButton(
                  onPressed: () =>
                      controller.setFilter('waiting for doctor approval'),
                  child: Text('Waiting for Doctor Approval'.tr,
                      style:
                          TextStyle(color: Color.fromARGB(255, 106, 168, 219))),
                ),
                TextButton(
                  onPressed: () =>
                      controller.setFilter('waiting for your approval'),
                  child: Text('Waiting for Your Approval'.tr,
                      style:
                          TextStyle(color: Color.fromARGB(255, 106, 168, 219))),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          final filteredReservations = controller.getFilteredReservations();
          if (filteredReservations.isEmpty) {
            return customRefreshIndicator(
              () async {
                controller.reservations.value = [];
                controller.onInit();
              },
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Center(
                        child: Text(
                          "No appointments".tr,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return customRefreshIndicator(
              () async {
                controller.reservations.value = [];
                controller.onInit();
              },
              ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: filteredReservations.length,
                itemBuilder: (context, index) {
                  final reservation = filteredReservations[index];
                  return _buildReservationCard(reservation, context);
                },
              ),
            );
          }
        }
      }),
    );
  }

  Widget _buildConfirmedReservations() {
    return Obx(() {
      final confirmedReservations = controller.reservations
          .where((r) => r.status == "confirmed")
          .toList();
      return ListView.builder(
        itemCount: confirmedReservations.length,
        itemBuilder: (context, index) {
          final reservation = confirmedReservations[index];
          return _buildReservationCard(reservation, context);
        },
      );
    });
  }

  Widget _buildPendingReservations(BuildContext context) {
    return Obx(() {
      final waitingForDoctorApprovalReservations = controller.reservations
          .where((r) => r.status == "waiting for doctor approval")
          .toList();
      final waitingForYourApprovalReservations = controller.reservations
          .where((r) => r.status == "waiting for your approval")
          .toList();

      return ListView(
        children: [
          ExpansionTile(
            title: Text("Waiting for Doctor Approval",
                style: Theme.of(context).textTheme.bodyMedium),
            children: waitingForDoctorApprovalReservations
                .map<Widget>((reservation) =>
                    _buildReservationCard(reservation, context))
                .toList(),
          ),
          ExpansionTile(
            title: Text("Waiting for Your Approval",
                style: Theme.of(context).textTheme.bodyMedium),
            children: waitingForYourApprovalReservations
                .map<Widget>((reservation) =>
                    _buildReservationCard(reservation, context))
                .toList(),
          ),
        ],
      );
    });
  }

  Widget _buildReservationCard(Reservation reservation, BuildContext context) {
    String formattedDateTime = reservation.dateTime != null
        ? DateFormat('yyyy-MM-dd – HH:mm').format(reservation.dateTime)
        : 'No Date Provided';

    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(reservation.doctorName,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05)),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            if (reservation.status != "waiting for doctor approval")
              Text(formattedDateTime, // Conditionally display the date
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            if (reservation.status == "confirmed" ||
                reservation.status == "waiting for doctor approval")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _showCancelConfirmation(
                        reservation, context, reservation.id),
                    child: Text('Cancel Reservation'.tr),
                  ),
                  if (reservation.status ==
                      "confirmed") // Check if the reservation is confirmed
                    ElevatedButton(
                      onPressed: () {
                        context.read<VideoCallBloc>().cachedAppointmentId =
                            reservation.id;
                        controller.ShowAppointmentStatus(
                            reservation.id, reservation.specialistId);
                      },
                      child: Text('Enter Session'.tr),
                    ),
                ],
              ),
            if (reservation.status == "waiting for your approval")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _showApprovalConfirmation(
                        context, reservation.id, true),
                    child: Text('Confirm'.tr),
                  ),
                  ElevatedButton(
                    onPressed: () => _showCancelConfirmation(
                        reservation, context, reservation.id),
                    child: Text('Cancel'.tr),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showCancelConfirmation(
      Reservation reservation, BuildContext context, String id) {
    Get.defaultDialog(
      title: "Cancel Reservation".tr,
      titleStyle: TextStyle(color: Color(0xFF00ADB5)),
      content: Obx(() {
        return controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(
                    10), // Add padding to make the dialog bigger
                child: Text(
                  "Are you sure you want to cancel this reservation?".tr,
                  style: TextStyle(color: Colors.white),
                ),
              );
      }),
      barrierDismissible:
          true, // Optional: Prevents closing the dialog by tapping outside
      radius: 8, // Optional: Adjust the border radius of the dialog
      contentPadding: EdgeInsets.symmetric(
          horizontal: 40, vertical: 20), // Adjust dialog internal padding
      onCancel: () {},
      onConfirm: () {
        if (reservation.status == "confirmed") {
          if (1 == 2) {
            customSnackBar(
                "Failed", "You can't cancel the session before 2 hours or less",
                backgroundColor: Colors.red, colorText: Colors.white);
          } else {
            controller.cancelAppointment(id);
          }
        } else {
          controller.cancelRequest(id);
        }
        Navigator.pop(context);
      },
    );
  }

  void _showApprovalConfirmation(
      BuildContext context, String id, bool approve) {
    Get.defaultDialog(
      title: approve ? "Confirm Reservation".tr : "Cancel Reservation".tr,
      titleStyle: TextStyle(color: Color(0xFF00ADB5)),
      content: Obx(() {
        return controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(
                    10), // Add padding to make the dialog bigger
                child: Text(
                  approve
                      ? "Are you sure you want to confirm this reservation?".tr
                      : "Are you sure you want to cancel this reservation?".tr,
                  style: TextStyle(color: Colors.white),
                ),
              );
      }),
      barrierDismissible:
          true, // Optional: Prevents closing the dialog by tapping outside
      radius: 8, // Optional: Adjust the border radius of the dialog
      contentPadding: EdgeInsets.symmetric(
          horizontal: 40, vertical: 20), // Adjust dialog internal padding
      onCancel: () {},
      onConfirm: () {
        if (approve) {
          controller.approveReservation(id);
        } else {
          controller.cancelRequest(id);
        }
        Navigator.pop(context);
      },
    );
  }
}
