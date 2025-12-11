// To parse this JSON data, do
//
//     final classesModel = classesModelFromJson(jsonString);

import 'dart:convert';

ClassesModel classesModelFromJson(String str) =>
    ClassesModel.fromJson(json.decode(str));

String classesModelToJson(ClassesModel data) => json.encode(data.toJson());

class ClassesModel {
  bool success;
  String message;
  List<Class> data;

  ClassesModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ClassesModel.fromJson(Map<String, dynamic> json) => ClassesModel(
        success: json["success"],
        message: json["message"],
        data: List<Class>.from(json["data"].map((x) => Class.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Class {
  int classId;
  String name;

  Class({
    required this.classId,
    required this.name,
  });

  factory Class.fromJson(Map<String, dynamic> json) => Class(
        classId: json["class_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "class_id": classId,
        "name": name,
      };
}
