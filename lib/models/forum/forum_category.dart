// To parse this JSON data, do
//
//     final forumCategory = forumCategoryFromJson(jsonString);

import 'dart:convert';

ForumCategory forumCategoryFromJson(String str) =>
    ForumCategory.fromJson(json.decode(str));

String forumCategoryToJson(ForumCategory data) => json.encode(data.toJson());

class ForumCategory {
  bool? success;
  int? code;
  String? message;
  List<ForumCategoryBody>? data;
  Metadata? metadata;

  ForumCategory({
    this.success,
    this.code,
    this.message,
    this.data,
    this.metadata,
  });

  factory ForumCategory.fromJson(Map<String, dynamic> json) => ForumCategory(
        success: json["success"],
        code: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<ForumCategoryBody>.from(
                json["data"]!.map((x) => ForumCategoryBody.fromJson(x))),
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

class ForumCategoryBody {
  int? id;
  String? name;
  String? nameFr;
  String? icon;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;
  int? totalTopics;

  bool isSelect = false;

  ForumCategoryBody({
    this.id,
    this.name,
    this.nameFr,
    this.icon,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.totalTopics,
  });

  factory ForumCategoryBody.fromJson(Map<String, dynamic> json) =>
      ForumCategoryBody(
        id: json["id"],
        name: json["name"],
        nameFr: json["nameFr"],
        icon: json["icon"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        status: json["status"],
        totalTopics: json["totalTopics"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nameFr": nameFr,
        "icon": icon,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "status": status,
        "totalTopics": totalTopics,
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
