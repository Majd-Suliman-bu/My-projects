// To parse this JSON data, do
//
//     final appointmentsResponse = appointmentsResponseFromJson(jsonString);

import 'dart:convert';

AppointmentsResponse appointmentsResponseFromJson(String str) =>
    AppointmentsResponse.fromJson(json.decode(str));

String appointmentsResponseToJson(AppointmentsResponse data) =>
    json.encode(data.toJson());

class AppointmentsResponse {
  bool success;
  String message;
  List<Datum> data;

  AppointmentsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AppointmentsResponse.fromJson(Map<String, dynamic> json) =>
      AppointmentsResponse(
        success: json["success"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  List<dynamic>? appointments;
  AppointmentRequests? appointmentRequests;

  Datum({
    this.appointments,
    this.appointmentRequests,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        appointments: json["appointments"] == null
            ? []
            : List<dynamic>.from(json["appointments"]!.map((x) => x)),
        appointmentRequests: json["appointmentRequests"] == null
            ? null
            : AppointmentRequests.fromJson(json["appointmentRequests"]),
      );

  Map<String, dynamic> toJson() => {
        "appointments": appointments == null
            ? []
            : List<dynamic>.from(appointments!.map((x) => x)),
        "appointmentRequests": appointmentRequests?.toJson(),
      };
}

class AppointmentRequests {
  List<AppointmentRequestsWaitForSpec> appointmentRequestsWaitForSpec;
  List<dynamic> appointmentRequestsWaitForUser;

  AppointmentRequests({
    required this.appointmentRequestsWaitForSpec,
    required this.appointmentRequestsWaitForUser,
  });

  factory AppointmentRequests.fromJson(Map<String, dynamic> json) =>
      AppointmentRequests(
        appointmentRequestsWaitForSpec:
            List<AppointmentRequestsWaitForSpec>.from(
                json["appointmentRequests_waitForSpec"]
                    .map((x) => AppointmentRequestsWaitForSpec.fromJson(x))),
        appointmentRequestsWaitForUser: List<dynamic>.from(
            json["appointmentRequests_waitForUser"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "appointmentRequests_waitForSpec": List<dynamic>.from(
            appointmentRequestsWaitForSpec.map((x) => x.toJson())),
        "appointmentRequests_waitForUser":
            List<dynamic>.from(appointmentRequestsWaitForUser.map((x) => x)),
      };
}

class AppointmentRequestsWaitForSpec {
  int id;
  dynamic status;
  dynamic patientApprove;
  String description;
  dynamic proposedDate;
  int patientId;
  String patientName;
  String specialistName;

  AppointmentRequestsWaitForSpec({
    required this.id,
    required this.status,
    required this.patientApprove,
    required this.description,
    required this.proposedDate,
    required this.patientId,
    required this.patientName,
    required this.specialistName,
  });

  factory AppointmentRequestsWaitForSpec.fromJson(Map<String, dynamic> json) =>
      AppointmentRequestsWaitForSpec(
        id: json["id"],
        status: json["status"],
        patientApprove: json["patientApprove"],
        description: json["description"],
        proposedDate: json["proposedDate"],
        patientId: json["patientId"],
        patientName: json["patientName"],
        specialistName: json["specialistName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "patientApprove": patientApprove,
        "description": description,
        "proposedDate": proposedDate,
        "patientId": patientId,
        "patientName": patientName,
        "specialistName": specialistName,
      };
}
