// To parse this JSON data, do
//
//     final appointments = appointmentsFromJson(jsonString);

import 'dart:convert';

Appointments appointmentsFromJson(String str) {
  final jsonData = json.decode(str);
  return Appointments.fromJson(jsonData);
}

class Appointments {
  bool success;
  String message;
  List<Datum> data;

  Appointments({
    required this.success,
    required this.message,
    required this.data,
  });

  factory Appointments.fromJson(Map<String, dynamic> json) => Appointments(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  List<Appointment>? appointments;
  AppointmentRequests? appointmentRequests;

  Datum({
    this.appointments,
    this.appointmentRequests,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        appointments: json["appointments"] == null
            ? []
            : List<Appointment>.from(
                json["appointments"]!.map((x) => Appointment.fromJson(x))),
        appointmentRequests: json["appointmentRequests"] == null
            ? null
            : AppointmentRequests.fromJson(json["appointmentRequests"]),
      );

  Map<String, dynamic> toJson() => {
        "appointments": appointments == null
            ? []
            : List<dynamic>.from(appointments!.map((x) => x.toJson())),
        "appointmentRequests": appointmentRequests?.toJson(),
      };
}

class AppointmentRequests {
  List<AppointmentRequestsWaitFor> appointmentRequestsWaitForSpec;
  List<AppointmentRequestsWaitFor> appointmentRequestsWaitForUser;

  AppointmentRequests({
    required this.appointmentRequestsWaitForSpec,
    required this.appointmentRequestsWaitForUser,
  });

  factory AppointmentRequests.fromJson(Map<String, dynamic> json) =>
      AppointmentRequests(
        appointmentRequestsWaitForSpec: List<AppointmentRequestsWaitFor>.from(
            json["appointmentRequests_waitForSpec"]
                .map((x) => AppointmentRequestsWaitFor.fromJson(x))),
        appointmentRequestsWaitForUser: List<AppointmentRequestsWaitFor>.from(
            json["appointmentRequests_waitForUser"]
                .map((x) => AppointmentRequestsWaitFor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "appointmentRequests_waitForSpec": List<dynamic>.from(
            appointmentRequestsWaitForSpec.map((x) => x.toJson())),
        "appointmentRequests_waitForUser": List<dynamic>.from(
            appointmentRequestsWaitForUser.map((x) => x.toJson())),
      };
}

class AppointmentRequestsWaitFor {
  int id;
  bool? status;
  dynamic patientApprove;
  Description? description;
  DateTime? proposedDate;
  String patientName;
  String specialistName;

  AppointmentRequestsWaitFor({
    required this.id,
    required this.status,
    required this.patientApprove,
    this.description,
    required this.proposedDate,
    required this.patientName,
    required this.specialistName,
  });

  factory AppointmentRequestsWaitFor.fromJson(Map<String, dynamic> json) =>
      AppointmentRequestsWaitFor(
        id: json["id"],
        status: json["status"],
        patientApprove: json["patientApprove"],
        description: descriptionValues.map[json["description"]],
        proposedDate: json["proposedDate"] == null
            ? null
            : DateTime.parse(json["proposedDate"]),
        patientName: json["patientName"] ?? PatientName.PATIENT.name,
        specialistName: json["specialistName"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "patientApprove": patientApprove,
        "description": descriptionValues.reverse[description],
        "proposedDate": proposedDate?.toIso8601String(),
        "patientName": patientNameValues.reverse[patientName],
        "specialistName": specialistNameValues.reverse[specialistName],
      };
}

enum Description { APPOINTMENT_REQUEST_DESCRIPTION }

final descriptionValues = EnumValues({
  "Appointment request description ":
      Description.APPOINTMENT_REQUEST_DESCRIPTION
});

enum PatientName { PATIENT }

final patientNameValues = EnumValues({"patient": PatientName.PATIENT});

enum SpecialistName { DOCTOR }

final specialistNameValues = EnumValues({"doctor": SpecialistName.DOCTOR});

class Appointment {
  int id;
  DateTime date;
  bool isCancelled;
  bool isCompleted;
  bool isReady;
  PatientName patientName;
  SpecialistName specialistName;

  Appointment({
    required this.id,
    required this.date,
    required this.isCancelled,
    required this.isCompleted,
    required this.isReady,
    required this.patientName,
    required this.specialistName,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        isCancelled: json["isCancelled"],
        isCompleted: json["isCompleted"],
        isReady: json["isReady"],
        patientName: json["patientName"] == null
            ? PatientName.PATIENT // Provide a default value or handle null
            : patientNameValues.map[json["patientName"]]!,
        specialistName: specialistNameValues.map[json["specialistName"]]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date.toIso8601String(),
        "isCancelled": isCancelled,
        "isCompleted": isCompleted,
        "isReady": isReady,
        "patientName": patientNameValues.reverse[patientName],
        "specialistName": specialistNameValues.reverse[specialistName],
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
