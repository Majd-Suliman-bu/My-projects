// To parse this JSON data, do
//
//     final doctorsList = doctorsListFromJson(jsonString);

import 'dart:convert';

DoctorsList doctorsListFromJson(String str) =>
    DoctorsList.fromJson(json.decode(str));

String doctorsListToJson(DoctorsList data) => json.encode(data.toJson());

class DoctorsList {
  bool? success;
  String? message;
  List<Datum> data;

  DoctorsList({
    this.success,
    this.message,
    required this.data,
  });

  factory DoctorsList.fromJson(Map<String, dynamic> json) => DoctorsList(
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
  String name;
  String photo;
  String city;

  Datum({
    required this.id,
    required this.name,
    required this.photo,
    required this.city,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        photo: json["photo"],
        city: json["city"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photo": photo,
        "city": city,
      };
}
