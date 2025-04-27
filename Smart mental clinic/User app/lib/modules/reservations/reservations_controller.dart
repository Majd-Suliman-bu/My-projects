import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_medical_clinic/shared_widget/custom_snack_bar.dart';
import '../../models/reservation.dart';
//import '../../models/appointments.dart';
import '../../models/appoints.dart';

import 'reservations_service.dart';

class ReservationsController extends GetxController {
  var isLoading = true.obs;
  var confirmedReservations = <Reservation>[].obs;
  var waitingForDoctorApprovalReservations = <Reservation>[].obs;
  var waitingForYourApprovalReservations = <Reservation>[].obs;
  var currentFilter = 'confirmed'.obs;
  final ReservationsService reservationsService = ReservationsService();
  late List<Datum> appointmentsData;
  var reservations = <Reservation>[].obs; // Define the main reservations list

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }

  void fetchAppointments() async {
    isLoading(true);
    try {
      appointmentsData = await reservationsService.GetAppointments();
      processAppointmentsData();
    } catch (e) {
      customSnackBar("Error", "Failed to fetch appointments: $e");
    } finally {
      isLoading(false);
    }
  }

  void processAppointmentsData() {
    confirmedReservations.clear();
    waitingForDoctorApprovalReservations.clear();
    waitingForYourApprovalReservations.clear();

    for (var datum in appointmentsData) {
      if (datum.appointments != null) {
        confirmedReservations
            .addAll(datum.appointments!.map((appointment) => Reservation(
                  id: appointment['id'].toString(),
                  specialistId: appointment['specialistId'],
                  doctorName: appointment['specialistName'] ?? "Unknown Doctor",
                  dateTime: DateTime.parse(appointment['date']),
                  status: "confirmed",
                )));
      }
      if (datum.appointmentRequests?.appointmentRequestsWaitForSpec != null) {
        waitingForDoctorApprovalReservations.addAll(datum
            .appointmentRequests!.appointmentRequestsWaitForSpec
            .map((request) => Reservation(
                  id: request.id.toString(),
                  specialistId: -1,
                  doctorName: request.specialistName ?? "Unknown Doctor",
                  dateTime: DateTime.now(), // Placeholder date
                  status: "waiting for doctor approval",
                )));
      }
      if (datum.appointmentRequests?.appointmentRequestsWaitForUser != null) {
        waitingForYourApprovalReservations.addAll(datum
            .appointmentRequests!.appointmentRequestsWaitForUser
            .map((request) => Reservation(
                  id: request['id'].toString(),
                  specialistId: -1,
                  doctorName: request['specialistName'] ?? "Unknown Doctor",
                  dateTime: request['proposedDate'] != null
                      ? DateTime.parse(request['proposedDate'])
                      : DateTime.now(), // Handle null date
                  status: "waiting for your approval",
                )));
      }
    }
    updateReservationsList();
  }

  void updateReservationsList() {
    reservations.clear();
    switch (currentFilter.value) {
      case 'confirmed':
        reservations.addAll(confirmedReservations);
        break;
      case 'waiting for doctor approval':
        reservations.addAll(waitingForDoctorApprovalReservations);
        break;
      case 'waiting for your approval':
        reservations.addAll(waitingForYourApprovalReservations);
        break;
    }
    isLoading(false);
  }

  void setFilter(String filter) {
    currentFilter.value = filter;
    updateReservationsList();
  }

  // Expanded dummy data for testing
  List<Reservation> getFilteredReservations() {
    switch (currentFilter.value) {
      case 'confirmed':
        return reservations.where((r) => r.status == "confirmed").toList();
      case 'waiting for doctor approval':
        return reservations
            .where((r) => r.status == "waiting for doctor approval")
            .toList();
      case 'waiting for your approval':
        return reservations
            .where((r) => r.status == "waiting for your approval")
            .toList();
      default:
        return [];
    }
  }

  void cancelRequest(String id) async {
    isLoading(true);
    try {
      // Convert id to int assuming it's stored as a string in Reservation
      int reservationId = int.parse(id);
      bool result = await reservationsService.RemoveAppointment(reservationId);
      isLoading(false);
      if (result) {
        // Proceed with removing the reservation from the list if the API call was successful
        // reservations.removeWhere((reservation) => reservation.id == id);
        onInit(); // Re-initialize the controller to refresh the entire page
        customSnackBar("Success".tr,
            "Your reservation has been successfully cancelled.".tr,
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        customSnackBar("Error".tr, ReservationsService.error,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      // Handle any exceptions thrown by the RemoveAppointment method
      customSnackBar("Error".tr, e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void cancelAppointment(String id) async {
    isLoading(true);
    try {
      // Convert id to int assuming it's stored as a string in Reservation
      int reservationId = int.parse(id);
      bool result = await reservationsService.CancelAppointment(reservationId);
      isLoading(false);
      if (result) {
        // Proceed with removing the reservation from the list if the API call was successful
        // reservations.removeWhere((reservation) => reservation.id == id);
        onInit(); // Re-initialize the controller to refresh the entire page
        customSnackBar("Success".tr,
            "Your reservation has been successfully cancelled.".tr,
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        customSnackBar("Error".tr, ReservationsService.error,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      // Handle any exceptions thrown by the CancelAppointment method
      customSnackBar("Error".tr, e.toString(),
          backgroundColor: Colors.red,
          colorText:
              Colors.white); // Display the error message from the service
    }
  }

  void approveReservation(String id) async {
    isLoading(true);
    try {
      // Convert id to int assuming it's stored as a string in Reservation
      int reservationId = int.parse(id);
      bool result = await reservationsService.AcceptAppointment(reservationId);
      isLoading(false);
      if (result) {
        onInit(); // Re-initialize the controller to refresh the entire page
        customSnackBar("Reservation Approved".tr,
            "Your reservation has been successfully approved.".tr,
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        customSnackBar("Failed to approve".tr, ReservationsService.error,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      // Handle any exceptions thrown by the AcceptAppointment method
      customSnackBar("Error".tr,
          e.toString()); // Display the error message from the service
    }
  }

  void ShowAppointmentStatus(String id, int therapistId) async {
    // Convert id to int assuming it's stored as a string in Reservation
    int reservationId = int.parse(id);
    bool result =
        await reservationsService.ShowAppointmentStatus(reservationId);
    print("resualt is ::::::: $result");
    // result = true;
    if (result) {
      Get.toNamed("/VideoCallInitPage", arguments: therapistId);
      customSnackBar("Session time",
          "Your can enter the video call by pressing the button.",
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      // Handle any exceptions thrown by the AcceptAppointment method
      customSnackBar("Error".tr, ReservationsService.error,
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
