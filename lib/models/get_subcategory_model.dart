// To parse this JSON data, do
//
//     final getSubCategoryModel = getSubCategoryModelFromJson(jsonString);

import 'dart:convert';

GetSubCategoryModel getSubCategoryModelFromJson(String str) =>
    GetSubCategoryModel.fromJson(json.decode(str));

String getSubCategoryModelToJson(GetSubCategoryModel data) =>
    json.encode(data.toJson());

class GetSubCategoryModel {
  bool? success;
  int? code;
  String? message;
  List<GetSubCategoryBody>? data;
  Metadata? metadata;

  GetSubCategoryModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.metadata,
  });

  factory GetSubCategoryModel.fromJson(Map<String, dynamic> json) =>
      GetSubCategoryModel(
        success: json["success"],
        code: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<GetSubCategoryBody>.from(
                json["data"]!.map((x) => GetSubCategoryBody.fromJson(x))),
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

class GetSubCategoryBody {
  int? id;
  int? categoryId;
  String? name;
  String? nameFr;
  String? icon;
  List<QuestionSub>? questions;

  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;
  Category? category;
  bool isSelect = false;

  GetSubCategoryBody({
    this.id,
    this.categoryId,
    this.name,
    this.nameFr,
    this.icon,
    this.questions,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.category,
  });

  factory GetSubCategoryBody.fromJson(Map<String, dynamic> json) =>
      GetSubCategoryBody(
        id: json["id"],
        categoryId: json["categoryId"],
        name: json["name"],
        nameFr: json["nameFr"],
        icon: json["icon"],
        questions: json["questions"] == null
            ? []
            : List<QuestionSub>.from(
                json["questions"]!.map((x) => QuestionSub.fromJson(x))),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        status: json["status"],
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoryId": categoryId,
        "name": name,
        "nameFr": nameFr,
        "icon": icon,
        "questions": questions == null
            ? []
            : List<dynamic>.from(questions!.map((x) => x.toJson())),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "status": status,
        "category": category?.toJson(),
      };
}

class Category {
  int? id;
  String? name;
  String? nameFr;
  String? icon;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;

  Category({
    this.id,
    this.name,
    this.nameFr,
    this.icon,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nameFr": nameFr,
        "icon": icon,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "status": status,
      };
}

class QuestionSub {
  String? questionEn;
  String? questionFr;
  String selectedAns = "";
  String selectedAnsFr = "";
  int selectedStar = -1;
  List<StarText>? starText;

  QuestionSub({
    this.questionEn,
    this.questionFr,
    this.starText,
  });

  factory QuestionSub.fromJson(Map<String, dynamic> json) => QuestionSub(
        questionEn: json["question_en"],
        questionFr: json["question_fr"],
        starText: json["starText"] == null
            ? []
            : List<StarText>.from(
                json["starText"]!.map((x) => StarText.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "question_en": questionEn,
        "question_fr": questionFr,
        "starText": starText == null
            ? []
            : List<dynamic>.from(starText!.map((x) => x.toJson())),
      };
}

class StarText {
  String? textEn;
  String? textFr;
  String? selectStar = "-1";

  StarText({
    this.textEn,
    this.textFr,
  });

  factory StarText.fromJson(Map<String, dynamic> json) => StarText(
        textEn: json["text_en"],
        textFr: json["text_fr"],
      );

  Map<String, dynamic> toJson() => {
        "text_en": textEn,
        "text_fr": textFr,
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
