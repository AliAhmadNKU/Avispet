// To parse this JSON data, do
//
//     final getAllPostModel = getAllPostModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

GetAllPostModel getAllPostModelFromJson(String str) =>
    GetAllPostModel.fromJson(json.decode(str));

String getAllPostModelToJson(GetAllPostModel data) =>
    json.encode(data.toJson());

class GetAllPostModel {
  bool? success;
  int? code;
  String? message;
  List<GetAllPostModelBody>? data;
  Metadata? metadata;

  GetAllPostModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.metadata,
  });

  factory GetAllPostModel.fromJson(Map<String, dynamic> json) =>
      GetAllPostModel(
        success: json["success"],
        code: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<GetAllPostModelBody>.from(
                json["data"]!.map((x) => GetAllPostModelBody.fromJson(x))),
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

class GetAllPostModelBody {
  String? createdAt;
  int? id;
  String? tagId;

  DateTime? updatedAt;

  int? userId;

  dynamic favoriteFeed;
  List<FeedImage>? feedImages;
  User? user;
  String? blockBy;
  int? isBlock;
  int? totalComments;
  int? totalLikes;
  int? isLiked;
  int? isFav;
  int? hasFollowedUser;

  PageController pageController = PageController();

  bool likeEnable = false;
  bool bookmarkEnable = false;
  int localCommentStore = 0;
  int currentPage = 0;

  GetAllPostModelBody({
    this.createdAt,
    this.id,
    this.tagId,
    this.updatedAt,
    this.userId,
    this.favoriteFeed,
    this.feedImages,
    this.user,
    this.totalComments,
    this.isBlock,
    this.blockBy,
    this.totalLikes,
    this.isLiked,
    this.isFav,
    this.hasFollowedUser,
  });

  factory GetAllPostModelBody.fromJson(Map<String, dynamic> json) =>
      GetAllPostModelBody(
        createdAt: json["createdAt"],
        id: json["id"],
        tagId: json["tagId"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        userId: json["userId"],
        favoriteFeed: json["favorite_feed"],
        feedImages: json["feed_images"] == null
            ? []
            : List<FeedImage>.from(
                json["feed_images"]!.map((x) => FeedImage.fromJson(x))),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        blockBy: json["blockBy"],
        isBlock: json["isBlock"],
        totalComments: json["totalComments"],
        totalLikes: json["totalLikes"],
        isLiked: json["isLiked"],
        isFav: json["isFav"],
        hasFollowedUser: json["hasFollowedUser"],
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt,
        "id": id,
        "tagId": tagId,
        "updatedAt": updatedAt?.toIso8601String(),
        "userId": userId,
        "favorite_feed": favoriteFeed,
        "feed_images": feedImages == null
            ? []
            : List<dynamic>.from(feedImages!.map((x) => x.toJson())),
        "user": user?.toJson(),
        "totalComments": totalComments,
        "isBlock": isBlock,
        "blockBy": blockBy,
        "totalLikes": totalLikes,
        "isLiked": isLiked,
        "isFav": isFav,
        "hasFollowedUser": hasFollowedUser,
      };
}

class FeedImage {
  int? id;
  String? image;
  int currentPage = 0;

  FeedImage({
    this.id,
    this.image,
  });

  factory FeedImage.fromJson(Map<String, dynamic> json) => FeedImage(
        id: json["id"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
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

  Metadata({
    this.totalRecords,
    this.totalPages,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        totalRecords: json["totalRecords"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "totalRecords": totalRecords,
        "totalPages": totalPages,
      };
}
