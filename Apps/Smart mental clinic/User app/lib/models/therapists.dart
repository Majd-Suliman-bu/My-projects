// To parse this JSON data, do
//
//     final therapists = therapistsFromJson(jsonString);

import 'dart:convert';

Therapists therapistsFromJson(String str) =>
    Therapists.fromJson(json.decode(str));

String therapistsToJson(Therapists data) => json.encode(data.toJson());

class Therapists {
  bool success;
  String message;
  List<Datum> data;

  Therapists({
    required this.success,
    required this.message,
    required this.data,
  });

  factory Therapists.fromJson(Map<String, dynamic> json) => Therapists(
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
  int id;
  String channelName;
  int patientId;
  int specId;
  String specialistName;
  String specialistPhoto;
  String token;
  int roleId;

  Datum({
    required this.id,
    required this.channelName,
    required this.patientId,
    required this.specId,
    required this.specialistName,
    required this.specialistPhoto,
    required this.token,
    required this.roleId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        channelName: json["channelName"],
        patientId: json["patientId"],
        specId: json["specId"],
        specialistName: json["specialistName"],
        specialistPhoto: json["specialistPhoto"],
        token: json["token"],
        roleId: json["roleId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "channelName": channelName,
        "patientId": patientId,
        "specId": specId,
        "specialistName": specialistName,
        "specialistPhoto": specialistPhoto,
        "token": token,
        "roleId": roleId,
      };
}
