// To parse this JSON data, do
//
//     final getDogBreed = getDogBreedFromJson(jsonString);

import 'dart:convert';

GetDogBreed getDogBreedFromJson(String str) =>
    GetDogBreed.fromJson(json.decode(str));

String getDogBreedToJson(GetDogBreed data) => json.encode(data.toJson());

class GetDogBreed {
  bool? success;
  int? code;
  String? message;
  List<GetDogBreedBody>? data;
  Metadata? metadata;

  GetDogBreed({
    this.success,
    this.code,
    this.message,
    this.data,
    this.metadata,
  });

  factory GetDogBreed.fromJson(Map<String, dynamic> json) => GetDogBreed(
        success: json["success"],
        code: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<GetDogBreedBody>.from(
                json["data"]!.map((x) => GetDogBreedBody.fromJson(x))),
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

class GetDogBreedBody {
  int? id;
  String? name;
  String? nameFr;
  DateTime? createdAt;
  DateTime? updatedAt;

  bool isSelect = false;

  GetDogBreedBody({
    this.id,
    this.name,
    this.nameFr,
    this.createdAt,
    this.updatedAt,
  });

  factory GetDogBreedBody.fromJson(Map<String, dynamic> json) =>
      GetDogBreedBody(
        id: json["id"],
        name: json["name"],
        nameFr: json["nameFr"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nameFr": nameFr,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
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
