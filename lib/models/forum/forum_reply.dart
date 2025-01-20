// To parse this JSON data, do
//
//     final forumReplyModel = forumReplyModelFromJson(jsonString);

import 'dart:convert';

ForumReplyModel forumReplyModelFromJson(String str) =>
    ForumReplyModel.fromJson(json.decode(str));

String forumReplyModelToJson(ForumReplyModel data) =>
    json.encode(data.toJson());

class ForumReplyModel {
  bool? success;
  int? code;
  String? message;
  List<ForumReplyBody>? data;
  Metadata? metadata;

  ForumReplyModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.metadata,
  });

  factory ForumReplyModel.fromJson(Map<String, dynamic> json) =>
      ForumReplyModel(
        success: json["success"],
        code: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<ForumReplyBody>.from(
                json["data"]!.map((x) => ForumReplyBody.fromJson(x))),
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

class ForumReplyBody {
  int? id;
  String? comment;
  var createdAt;
  var updatedAt;
  int? forumTopicId;
  int? userId;
  int? forumId;
  User? user;
  int? isLiked;
  int? totalLikes;

  bool moreClick = false;
  bool likeEnable = false;

  ForumReplyBody({
    this.id,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.forumTopicId,
    this.userId,
    this.forumId,
    this.user,
    this.isLiked,
    this.totalLikes,
  });

  factory ForumReplyBody.fromJson(Map<String, dynamic> json) => ForumReplyBody(
        id: json["id"],
        comment: json["comment"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        forumTopicId: json["forumTopicId"],
        userId: json["userId"],
        forumId: json["forumId"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        isLiked: json["isLiked"],
        totalLikes: json["totalLikes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "forumTopicId": forumTopicId,
        "userId": userId,
        "forumId": forumId,
        "user": user?.toJson(),
        "isLiked": isLiked,
        "totalLikes": totalLikes,
      };
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? profilePicture;
  int? isOnline;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.isOnline,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        profilePicture: json["profile_picture"],
        isOnline: json["is_online"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "profile_picture": profilePicture,
        "is_online": isOnline,
      };
}

class Metadata {
  int? totalRecords;
  int? totalPages;
  ForumData? forumData;
  ForumTopicData? forumTopicData;

  Metadata({
    this.totalRecords,
    this.totalPages,
    this.forumData,
    this.forumTopicData,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        totalRecords: json["totalRecords"],
        totalPages: json["totalPages"],
        forumData: json["forumData"] == null
            ? null
            : ForumData.fromJson(json["forumData"]),
        forumTopicData: json["forumTopicData"] == null
            ? null
            : ForumTopicData.fromJson(json["forumTopicData"]),
      );

  Map<String, dynamic> toJson() => {
        "totalRecords": totalRecords,
        "totalPages": totalPages,
        "forumData": forumData?.toJson(),
        "forumTopicData": forumTopicData?.toJson(),
      };
}

class ForumData {
  int? id;
  String? title;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;
  int? dogBreedId;

  ForumData({
    this.id,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.dogBreedId,
  });

  factory ForumData.fromJson(Map<String, dynamic> json) => ForumData(
        id: json["id"],
        title: json["title"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        status: json["status"],
        dogBreedId: json["dogBreedId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "status": status,
        "dogBreedId": dogBreedId,
      };
}

class ForumTopicData {
  int? id;
  String? referenceId;
  String? title;
  String? description;
  int? sendEmail;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;
  int? forumCategoryId;
  int? forumId;
  int? userId;

  ForumTopicData({
    this.id,
    this.referenceId,
    this.title,
    this.description,
    this.sendEmail,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.forumCategoryId,
    this.forumId,
    this.userId,
  });

  factory ForumTopicData.fromJson(Map<String, dynamic> json) => ForumTopicData(
        id: json["id"],
        referenceId: json["referenceId"],
        title: json["title"],
        description: json["description"],
        sendEmail: json["sendEmail"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        status: json["status"],
        forumCategoryId: json["forumCategoryId"],
        forumId: json["forumId"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "referenceId": referenceId,
        "title": title,
        "description": description,
        "sendEmail": sendEmail,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "status": status,
        "forumCategoryId": forumCategoryId,
        "forumId": forumId,
        "userId": userId,
      };
}
