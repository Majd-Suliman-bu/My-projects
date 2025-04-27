// To parse this JSON data, do
//
//     final mysubscriptionsModel = mysubscriptionsModelFromJson(jsonString);

import 'dart:convert';

MysubscriptionsModel mysubscriptionsModelFromJson(String str) =>
    MysubscriptionsModel.fromJson(json.decode(str));

String mysubscriptionsModelToJson(MysubscriptionsModel data) =>
    json.encode(data.toJson());

class MysubscriptionsModel {
  bool status;
  int statusCode;
  String msg;
  List<MyCourses> data;

  MysubscriptionsModel({
    required this.status,
    required this.statusCode,
    required this.msg,
    required this.data,
  });

  factory MysubscriptionsModel.fromJson(Map<String, dynamic> json) =>
      MysubscriptionsModel(
        status: json["status"],
        statusCode: json["statusCode"],
        msg: json["msg"],
        data: List<MyCourses>.from(
            json["data"].map((x) => MyCourses.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class MyCourses {
  int fee;
  DateTime expirationDate;
  int courseId;
  String courseTitle;

  MyCourses({
    required this.fee,
    required this.expirationDate,
    required this.courseId,
    required this.courseTitle,
  });

  factory MyCourses.fromJson(Map<String, dynamic> json) => MyCourses(
        fee: json["fee"],
        expirationDate: DateTime.parse(json["expiration_date"]),
        courseId: json["Course"]["course_id"],
        courseTitle: json["Course"]["title"],
      );

  Map<String, dynamic> toJson() => {
        "fee": fee,
        "expiration_date": expirationDate.toIso8601String(),
        "course_id": courseId,
        "course_title": courseTitle,
      };
}
