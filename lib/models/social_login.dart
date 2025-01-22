// To parse this JSON data, do
//
//     final socialLogin = socialLoginFromJson(jsonString);

import 'dart:convert';

SocialLogin socialLoginFromJson(String str) =>
    SocialLogin.fromJson(json.decode(str));

String socialLoginToJson(SocialLogin data) => json.encode(data.toJson());

class SocialLogin {
  bool? success;
  int? code;
  String? message;
  Data? data;
  Metadata? metadata;

  SocialLogin({
    this.success,
    this.code,
    this.message,
    this.data,
    this.metadata,
  });

  factory SocialLogin.fromJson(Map<String, dynamic> json) => SocialLogin(
        success: json["success"],
        code: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        metadata: json["metadata"] == null
            ? null
            : Metadata.fromJson(json["metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status": code,
        "message": message,
        "data": data?.toJson(),
        "metadata": metadata?.toJson(),
      };
}

class Data {
  int? id;
  String? token;
  String? firstName;
  String? lastName;
  String? name;
  String? email;
  String? socialId;
  String? socialType;
  dynamic profilePicture;
  dynamic coverPicture;
  dynamic address;
  dynamic alternativeAddress;
  dynamic city;
  dynamic state;
  dynamic pincode;
  String? latitude;
  String? longitude;
  dynamic profession;
  dynamic dob;
  int? age;
  String? gender;
  dynamic phoneNumber;
  dynamic biography;
  String? isEmailVerified;
  String? userType;
  bool? allowPushNotifications;
  String? timezone;
  dynamic verificationCode;
  String? deviceToken;
  String? deviceType;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? socketId;
  int? isOnline;
  int? gamePoints;
  int? deletePasscode;
  String? accountStatus;
  String? referralCode;
  dynamic pseudo;
  int? animalsCount;

  Data({
    this.id,
    this.token,
    this.firstName,
    this.lastName,
    this.name,
    this.email,
    this.socialId,
    this.socialType,
    this.profilePicture,
    this.coverPicture,
    this.address,
    this.alternativeAddress,
    this.city,
    this.state,
    this.pincode,
    this.latitude,
    this.longitude,
    this.profession,
    this.dob,
    this.age,
    this.gender,
    this.phoneNumber,
    this.biography,
    this.isEmailVerified,
    this.userType,
    this.allowPushNotifications,
    this.timezone,
    this.verificationCode,
    this.deviceToken,
    this.deviceType,
    this.createdAt,
    this.updatedAt,
    this.socketId,
    this.isOnline,
    this.gamePoints,
    this.deletePasscode,
    this.accountStatus,
    this.referralCode,
    this.pseudo,
    this.animalsCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        token: json["token"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        name: json["name"],
        email: json["email"],
        socialId: json["socialId"],
        socialType: json["socialType"],
        profilePicture: json["profilePicture"],
        coverPicture: json["coverPicture"],
        address: json["address"],
        alternativeAddress: json["alternativeAddress"],
        city: json["city"],
        state: json["state"],
        pincode: json["pincode"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        profession: json["profession"],
        dob: json["dob"],
        age: json["age"],
        gender: json["gender"],
        phoneNumber: json["phoneNumber"],
        biography: json["biography"],
        isEmailVerified: json["isEmailVerified"],
        userType: json["userType"],
        allowPushNotifications: json["allowPushNotifications"],
        timezone: json["timezone"],
        verificationCode: json["verificationCode"],
        deviceToken: json["deviceToken"],
        deviceType: json["deviceType"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        socketId: json["socket_id"],
        isOnline: json["isOnline"],
        gamePoints: json["gamePoints"],
        deletePasscode: json["delete_passcode"],
        accountStatus: json["accountStatus"],
        referralCode: json["referralCode"],
        pseudo: json["pseudo"],
        animalsCount: json["animalsCount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
        "firstName": firstName,
        "lastName": lastName,
        "name": name,
        "email": email,
        "socialId": socialId,
        "socialType": socialType,
        "profilePicture": profilePicture,
        "coverPicture": coverPicture,
        "address": address,
        "alternativeAddress": alternativeAddress,
        "city": city,
        "state": state,
        "pincode": pincode,
        "latitude": latitude,
        "longitude": longitude,
        "profession": profession,
        "dob": dob,
        "age": age,
        "gender": gender,
        "phoneNumber": phoneNumber,
        "biography": biography,
        "isEmailVerified": isEmailVerified,
        "userType": userType,
        "allowPushNotifications": allowPushNotifications,
        "timezone": timezone,
        "verificationCode": verificationCode,
        "deviceToken": deviceToken,
        "deviceType": deviceType,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "socket_id": socketId,
        "isOnline": isOnline,
        "gamePoints": gamePoints,
        "delete_passcode": deletePasscode,
        "accountStatus": accountStatus,
        "referralCode": referralCode,
        "pseudo": pseudo,
        "animalsCount": animalsCount,
      };
}

class Metadata {
  int? isNew;

  Metadata({
    this.isNew,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        isNew: json["isNew"],
      );

  Map<String, dynamic> toJson() => {
        "isNew": isNew,
      };
}
