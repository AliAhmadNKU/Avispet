// To parse this JSON data, do
//
//     final forumQuestionModel = forumQuestionModelFromJson(jsonString);

import 'dart:convert';

ForumQuestionModel forumQuestionModelFromJson(String str) =>
    ForumQuestionModel.fromJson(json.decode(str));

String forumQuestionModelToJson(ForumQuestionModel data) =>
    json.encode(data.toJson());

class ForumQuestionModel {
  bool? success;
  int? code;
  String? message;
  List<ForumQuestionBody>? data;
  Metadata? metadata;

  ForumQuestionModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.metadata,
  });

  factory ForumQuestionModel.fromJson(Map<String, dynamic> json) =>
      ForumQuestionModel(
        success: json["success"],
        code: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<ForumQuestionBody>.from(
                json["data"]!.map((x) => ForumQuestionBody.fromJson(x))),
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

class ForumQuestionBody {
  int? id;
  String? referenceId;
  String? title;
  String? description;
  int? sendEmail;
  var createdAt;
  var updatedAt;
  String? status;
  int? forumCategoryId;
  int? forumId;
  int? userId;
  User? user;
  int? totalReplies;
  bool moreClick = false;
  bool sendEmailEnable = false;

  ForumQuestionBody({
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
    this.user,
    this.totalReplies,
  });

  factory ForumQuestionBody.fromJson(Map<String, dynamic> json) =>
      ForumQuestionBody(
        id: json["id"],
        referenceId: json["referenceId"],
        title: json["title"],
        description: json["description"],
        sendEmail: json["sendEmail"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        status: json["status"],
        forumCategoryId: json["forumCategoryId"],
        forumId: json["forumId"],
        userId: json["userId"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        totalReplies: json["totalReplies"],
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
        "user": user?.toJson(),
        "totalReplies": totalReplies,
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

  Metadata({
    this.totalRecords,
    this.totalPages,
    this.forumData,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        totalRecords: json["totalRecords"],
        totalPages: json["totalPages"],
        forumData: json["forumData"] == null
            ? null
            : ForumData.fromJson(json["forumData"]),
      );

  Map<String, dynamic> toJson() => {
        "totalRecords": totalRecords,
        "totalPages": totalPages,
        "forumData": forumData?.toJson(),
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
