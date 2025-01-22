// To parse this JSON data, do
//
//     final likeUserModel = likeUserModelFromJson(jsonString);

import 'dart:convert';

LikeUserModel likeUserModelFromJson(String str) =>
    LikeUserModel.fromJson(json.decode(str));

String likeUserModelToJson(LikeUserModel data) => json.encode(data.toJson());

class LikeUserModel {
  bool? success;
  int? code;
  String? message;
  List<LikeUserBody>? data;
  Metadata? metadata;

  LikeUserModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.metadata,
  });

  factory LikeUserModel.fromJson(Map<String, dynamic> json) => LikeUserModel(
        success: json["success"],
        code: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<LikeUserBody>.from(
                json["data"]!.map((x) => LikeUserBody.fromJson(x))),
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

class LikeUserBody {
  String? createdAt;
  int? id;
  DateTime? updatedAt;
  int? feedId;
  int? userId;
  User? user;

  LikeUserBody({
    this.createdAt,
    this.id,
    this.updatedAt,
    this.feedId,
    this.userId,
    this.user,
  });

  factory LikeUserBody.fromJson(Map<String, dynamic> json) => LikeUserBody(
        createdAt: json["createdAt"],
        id: json["id"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        feedId: json["feedId"],
        userId: json["userId"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt,
        "id": id,
        "updatedAt": updatedAt?.toIso8601String(),
        "feedId": feedId,
        "userId": userId,
        "user": user?.toJson(),
      };
}

class User {
  int? id;
  String? name;
  String? profilePicture;

  User({
    this.id,
    this.name,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
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
  int? totalLikes;

  Metadata({
    this.totalRecords,
    this.totalPages,
    this.totalLikes,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        totalRecords: json["totalRecords"],
        totalPages: json["totalPages"],
        totalLikes: json["totalLikes"],
      );

  Map<String, dynamic> toJson() => {
        "totalRecords": totalRecords,
        "totalPages": totalPages,
        "totalLikes": totalLikes,
      };
}
