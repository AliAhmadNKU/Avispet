// To parse this JSON data, do
//
//     final myReplyTopic = myReplyTopicFromJson(jsonString);

import 'dart:convert';

MyReplyTopic myReplyTopicFromJson(String str) =>
    MyReplyTopic.fromJson(json.decode(str));

String myReplyTopicToJson(MyReplyTopic data) => json.encode(data.toJson());

class MyReplyTopic {
  bool? success;
  int? code;
  String? message;
  List<MyReplyTopicBody>? data;
  Metadata? metadata;

  MyReplyTopic({
    this.success,
    this.code,
    this.message,
    this.data,
    this.metadata,
  });

  factory MyReplyTopic.fromJson(Map<String, dynamic> json) => MyReplyTopic(
        success: json["success"],
        code: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<MyReplyTopicBody>.from(
                json["data"]!.map((x) => MyReplyTopicBody.fromJson(x))),
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

class MyReplyTopicBody {
  int? id;
  String? comment;
  String? createdAt;
  String? updatedAt;
  int? forumTopicId;
  int? userId;
  int? forumId;
  User? user;
  ForumTopic? forumTopic;
  int? totalReplies;
  int? isLiked;
  int? totalLikes;
  bool moreClick = false;
  bool likeEnable = false;

  MyReplyTopicBody({
    this.id,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.forumTopicId,
    this.userId,
    this.forumId,
    this.user,
    this.forumTopic,
    this.isLiked,
    this.totalLikes,
  });

  factory MyReplyTopicBody.fromJson(Map<String, dynamic> json) =>
      MyReplyTopicBody(
        id: json["id"],
        comment: json["comment"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        forumTopicId: json["forumTopicId"],
        userId: json["userId"],
        forumId: json["forumId"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        forumTopic: json["forum_topic"] == null
            ? null
            : ForumTopic.fromJson(json["forum_topic"]),
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
        "forum_topic": forumTopic?.toJson(),
        "isLiked": isLiked,
        "totalLikes": totalLikes,
      };
}

class ForumTopic {
  int? id;
  String? title;
  String? description;
  int? sendEmail;
  String? referenceId;
  Forum? forum;

  ForumTopic({
    this.id,
    this.title,
    this.description,
    this.sendEmail,
    this.referenceId,
    this.forum,
  });

  factory ForumTopic.fromJson(Map<String, dynamic> json) => ForumTopic(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        sendEmail: json["send_email"],
        referenceId: json["reference_id"],
        forum: json["forum"] == null ? null : Forum.fromJson(json["forum"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "send_email": sendEmail,
        "reference_id": referenceId,
        "forum": forum?.toJson(),
      };
}

class Forum {
  int? id;
  String? title;
  DogBreed? dogBreed;

  Forum({
    this.id,
    this.title,
    this.dogBreed,
  });

  factory Forum.fromJson(Map<String, dynamic> json) => Forum(
        id: json["id"],
        title: json["title"],
        dogBreed: json["dog_breed"] == null
            ? null
            : DogBreed.fromJson(json["dog_breed"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "dog_breed": dogBreed?.toJson(),
      };
}

class DogBreed {
  int? id;
  String? name;

  DogBreed({
    this.id,
    this.name,
  });

  factory DogBreed.fromJson(Map<String, dynamic> json) => DogBreed(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
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
