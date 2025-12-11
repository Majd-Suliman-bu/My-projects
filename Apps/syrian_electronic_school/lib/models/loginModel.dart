// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  bool status;
  int statusCode;
  String msg;
  Data data;

  LoginModel({
    required this.status,
    required this.statusCode,
    required this.msg,
    required this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    status: json["status"],
    statusCode: json["statusCode"],
    msg: json["msg"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "msg": msg,
    "data": data.toJson(),
  };
}

class Data {
  int id;
  String accessToken;
  String refreshToken;
  String firstName;
  String lastName;
  Interest interest;

  Data({
    required this.id,
    required this.accessToken,
    required this.refreshToken,
    required this.firstName,
    required this.lastName,
    required this.interest,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    accessToken: json["accessToken"],
    refreshToken: json["refreshToken"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    interest: Interest.fromJson(json["interest"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "accessToken": accessToken,
    "refreshToken": refreshToken,
    "first_name": firstName,
    "last_name": lastName,
    "interest": interest.toJson(),
  };
}

class Interest {
  int classId;
  String name;

  Interest({
    required this.classId,
    required this.name,
  });

  factory Interest.fromJson(Map<String, dynamic> json) => Interest(
    classId: json["class_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "class_id": classId,
    "name": name,
  };
}
