// To parse this JSON data, do
//
//     final doctorProfile = doctorProfileFromJson(jsonString);

import 'dart:convert';

DoctorProfile doctorProfileFromJson(String str) =>
    DoctorProfile.fromJson(json.decode(str));

String doctorProfileToJson(DoctorProfile data) => json.encode(data.toJson());

class DoctorProfile {
  bool success;
  String message;
  Data data;

  DoctorProfile({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DoctorProfile.fromJson(Map<String, dynamic> json) => DoctorProfile(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  int id;
  String name;
  String photo;
  String city;
  String specializationInfo;
  String studyInfo;
  int clinicId;
  String address;
  int sessionPrice;
  String sessionTime;

  Data({
    required this.id,
    required this.name,
    required this.photo,
    required this.city,
    required this.specializationInfo,
    required this.studyInfo,
    required this.clinicId,
    required this.address,
    required this.sessionPrice,
    required this.sessionTime,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        photo: json["photo"],
        city: json["city"],
        specializationInfo: json["specializationInfo"] ?? 'Not set',
        studyInfo: json["studyInfo"] ?? 'Not set',
        clinicId: json["clinicId"],
        address: json["address"],
        sessionPrice: json["sessionPrice"] ?? 30000,
        sessionTime: json["sessionTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photo": photo,
        "city": city,
        "specializationInfo": specializationInfo,
        "studyInfo": studyInfo,
        "clinicId": clinicId,
        "address": address,
        "sessionPrice": sessionPrice,
        "sessionTime": sessionTime,
      };
}
