// To parse this JSON data, do
//
//     final sendFeedCommentModel = sendFeedCommentModelFromJson(jsonString);

import 'dart:convert';

import 'package:avispets/models/get_feed_comment_model.dart';

SendFeedCommentModel sendFeedCommentModelFromJson(String str) =>
    SendFeedCommentModel.fromJson(json.decode(str));

String sendFeedCommentModelToJson(SendFeedCommentModel data) =>
    json.encode(data.toJson());

class SendFeedCommentModel {
  bool? success;
  int? code;
  String? message;
  GetFeedCommentModelBody? data;
  Metadata? metadata;

  SendFeedCommentModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.metadata,
  });

  factory SendFeedCommentModel.fromJson(Map<String, dynamic> json) =>
      SendFeedCommentModel(
        success: json["success"],
        code: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : GetFeedCommentModelBody.fromJson(json["data"]),
        metadata: json["_metadata"] == null
            ? null
            : Metadata.fromJson(json["_metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status": code,
        "message": message,
        "data": data?.toJson(),
        "_metadata": metadata?.toJson(),
      };
}

/*class Data {
  String? createdAt;
  int? id;
  int? userId;
  String? comment;
  dynamic replyId;
  DateTime? updatedAt;
  int? feedId;
  User? user;

  Data({
    this.createdAt,
    this.id,
    this.userId,
    this.comment,
    this.replyId,
    this.updatedAt,
    this.feedId,
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    createdAt: json["createdAt"],
    id: json["id"],
    userId: json["userId"],
    comment: json["comment"],
    replyId: json["replyId"],
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    feedId: json["feedId"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt,
    "id": id,
    "userId": userId,
    "comment": comment,
    "replyId": replyId,
    "updatedAt": updatedAt?.toIso8601String(),
    "feedId": feedId,
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
}*/

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata();

  Map<String, dynamic> toJson() => {};
}
