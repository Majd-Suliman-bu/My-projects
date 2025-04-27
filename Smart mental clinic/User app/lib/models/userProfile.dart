// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) =>
    UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  bool success;
  String message;
  Data data;

  UserProfile({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
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
  String username;
  String email;
  String password;
  bool isActive;
  bool isBlocked;
  int blockCounter;
  dynamic blockedUntil;
  int alertCounter;
  bool isDeleted;
  dynamic deletedAt;
  int roleId;
  Wallet wallet;

  Data({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.isActive,
    required this.isBlocked,
    required this.blockCounter,
    required this.blockedUntil,
    required this.alertCounter,
    required this.isDeleted,
    required this.deletedAt,
    required this.roleId,
    required this.wallet,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        isActive: json["isActive"],
        isBlocked: json["isBlocked"],
        blockCounter: json["blockCounter"],
        blockedUntil: json["blockedUntil"],
        alertCounter: json["alertCounter"],
        isDeleted: json["isDeleted"],
        deletedAt: json["deletedAt"],
        roleId: json["roleId"],
        wallet: Wallet.fromJson(json["wallet"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "password": password,
        "isActive": isActive,
        "isBlocked": isBlocked,
        "blockCounter": blockCounter,
        "blockedUntil": blockedUntil,
        "alertCounter": alertCounter,
        "isDeleted": isDeleted,
        "deletedAt": deletedAt,
        "roleId": roleId,
        "wallet": wallet.toJson(),
      };
}

class Wallet {
  int id;
  int balance;

  Wallet({
    required this.id,
    required this.balance,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        id: json["id"],
        balance: json["balance"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "balance": balance,
      };
}
