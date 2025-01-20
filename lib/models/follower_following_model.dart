// To parse this JSON data, do
//
//     final followingFollowerModel = followingFollowerModelFromJson(jsonString);

import 'dart:convert';

FollowingFollowerModel followingFollowerModelFromJson(String str) =>
    FollowingFollowerModel.fromJson(json.decode(str));

String followingFollowerModelToJson(FollowingFollowerModel data) =>
    json.encode(data.toJson());

class FollowingFollowerModel {
  bool? success;
  int? code;
  String? message;
  List<FollowingFollowerBody>? data;
  Metadata? metadata;

  FollowingFollowerModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.metadata,
  });

  factory FollowingFollowerModel.fromJson(Map<String, dynamic> json) =>
      FollowingFollowerModel(
        success: json["success"],
        code: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<FollowingFollowerBody>.from(
                json["data"]!.map((x) => FollowingFollowerBody.fromJson(x))),
        metadata: json["_metadata"] == null
            ? null
            : Metadata.fromJson(json["_metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status": code,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "_metadata": metadata?.toJson(),
      };
}

class FollowingFollowerBody {
  String? createdAt;
  int? id;
  DateTime? updatedAt;
  int? userId;
  int? followId;
  Ref? followRef;
  Ref? userRef;
  int? isBlocked;

  bool createGroupSelect = false;

  FollowingFollowerBody({
    this.createdAt,
    this.id,
    this.updatedAt,
    this.userId,
    this.followId,
    this.followRef,
    this.userRef,
    this.isBlocked,
  });

  factory FollowingFollowerBody.fromJson(Map<String, dynamic> json) =>
      FollowingFollowerBody(
        createdAt: json["createdAt"],
        id: json["id"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        userId: json["userId"],
        followId: json["followId"],
        followRef:
            json["followRef"] == null ? null : Ref.fromJson(json["followRef"]),
        userRef: json["userRef"] == null ? null : Ref.fromJson(json["userRef"]),
        isBlocked: json["isBlocked"],
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt,
        "id": id,
        "updatedAt": updatedAt?.toIso8601String(),
        "userId": userId,
        "followId": followId,
        "followRef": followRef?.toJson(),
        "userRef": userRef?.toJson(),
        "isBlocked": isBlocked,
      };
}

class Ref {
  int? id;
  String? name;
  String? profilePicture;
  bool conditionCheck = false;

  Ref({
    this.id,
    this.name,
    this.profilePicture,
  });

  factory Ref.fromJson(Map<String, dynamic> json) => Ref(
        id: json["id"],
        name: json["name"],
        profilePicture: json["profile_picture"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profile_picture": profilePicture,
      };
}

class Metadata {
  int? totalRecords;
  int? totalPages;
  int? myFollowingsTotal;
  int? myFollowersTotal;

  Metadata({
    this.totalRecords,
    this.totalPages,
    this.myFollowingsTotal,
    this.myFollowersTotal,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        totalRecords: json["totalRecords"],
        totalPages: json["totalPages"],
        myFollowingsTotal: json["myFollowingsTotal"],
        myFollowersTotal: json["myFollowersTotal"],
      );

  Map<String, dynamic> toJson() => {
        "totalRecords": totalRecords,
        "totalPages": totalPages,
        "myFollowingsTotal": myFollowingsTotal,
        "myFollowersTotal": myFollowersTotal,
      };
}
