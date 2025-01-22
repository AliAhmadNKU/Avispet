// To parse this JSON data, do
//
//     final getCategoryModel = getCategoryModelFromJson(jsonString);

import 'dart:convert';

GetCategoryModel getCategoryModelFromJson(String str) =>
    GetCategoryModel.fromJson(json.decode(str));

String getCategoryModelToJson(GetCategoryModel data) =>
    json.encode(data.toJson());

class GetCategoryModel {
  bool? success;
  int? code;
  String? message;
  List<Datum>? data;
  Metadata? metadata;

  GetCategoryModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.metadata,
  });

  factory GetCategoryModel.fromJson(Map<String, dynamic> json) =>
      GetCategoryModel(
        success: json["success"],
        code: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
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

class Datum {
  int? id;
  String? name;
  String? nameFr;
  String? icon;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;
  List<Datum>? subCategories;
  int? categoryId;

  Datum({
    this.id,
    this.name,
    this.nameFr,
    this.icon,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.subCategories,
    this.categoryId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
        subCategories: json["sub_categories"] == null
            ? []
            : List<Datum>.from(
                json["sub_categories"]!.map((x) => Datum.fromJson(x))),
        categoryId: json["categoryId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nameFr": nameFr,
        "icon": icon,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "status": status,
        "sub_categories": subCategories == null
            ? []
            : List<dynamic>.from(subCategories!.map((x) => x.toJson())),
        "categoryId": categoryId,
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
