// To parse this JSON data, do
//
//     final getFeedCommentModel = getFeedCommentModelFromJson(jsonString);

import 'dart:convert';

GetFeedCommentModel getFeedCommentModelFromJson(String str) =>
    GetFeedCommentModel.fromJson(json.decode(str));

String getFeedCommentModelToJson(GetFeedCommentModel data) =>
    json.encode(data.toJson());

class GetFeedCommentModel {
  bool? success;
  int? code;
  String? message;
  List<GetFeedCommentModelBody>? data;
  Metadata? metadata;

  GetFeedCommentModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.metadata,
  });

  factory GetFeedCommentModel.fromJson(Map<String, dynamic> json) =>
      GetFeedCommentModel(
        success: json["success"],
        code: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<GetFeedCommentModelBody>.from(
                json["data"]!.map((x) => GetFeedCommentModelBody.fromJson(x))),
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

class GetFeedCommentModelBody {
  String? createdAt;
  int? id;
  int? userId;
  String? comment;
  dynamic replyId;
  DateTime? updatedAt;
  int? feedId;
  User? user;
  int? haveChildComments;
  int? isLiked;
  int? totalLikes;

  bool moreClick = false;
  bool likeEnable = false;

  GetFeedCommentModelBody({
    this.createdAt,
    this.id,
    this.userId,
    this.comment,
    this.replyId,
    this.updatedAt,
    this.feedId,
    this.user,
    this.haveChildComments,
    this.isLiked,
    this.totalLikes,
  });

  factory GetFeedCommentModelBody.fromJson(Map<String, dynamic> json) =>
      GetFeedCommentModelBody(
        createdAt: json["createdAt"],
        id: json["id"],
        userId: json["userId"],
        comment: json["comment"],
        replyId: json["replyId"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        feedId: json["feedId"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        haveChildComments: json["haveChildComments"],
        isLiked: json["isLiked"],
        totalLikes: json["totalLikes"],
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
        "haveChildComments": haveChildComments,
        "totalLikes": totalLikes,
        "isLiked": isLiked,
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
  int? totalComments;

  Metadata({
    this.totalRecords,
    this.totalPages,
    this.totalComments,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        totalRecords: json["totalRecords"],
        totalPages: json["totalPages"],
        totalComments: json["totalComments"],
      );

  Map<String, dynamic> toJson() => {
        "totalRecords": totalRecords,
        "totalPages": totalPages,
        "totalComments": totalComments,
      };
}
