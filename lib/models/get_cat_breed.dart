import 'dart:convert';

GetCatBreed getCatBreedFromJson(String str) =>
    GetCatBreed.fromJson(json.decode(str));

String getCatBreedToJson(GetCatBreed data) => json.encode(data.toJson());

class GetCatBreed {
  bool? success;
  int? code;
  String? message;
  List<GetCatBreedBody>? data;
  Metadata? metadata;

  GetCatBreed({
    this.success,
    this.code,
    this.message,
    this.data,
    this.metadata,
  });

  factory GetCatBreed.fromJson(Map<String, dynamic> json) => GetCatBreed(
        success: json["success"],
        code: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<GetCatBreedBody>.from(
                json["data"]!.map((x) => GetCatBreedBody.fromJson(x))),
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

class GetCatBreedBody {
  int? id;
  String? name;
  String? nameFr;
  DateTime? createdAt;
  DateTime? updatedAt;

  bool isSelect = false;

  GetCatBreedBody({
    this.id,
    this.name,
    this.nameFr,
    this.createdAt,
    this.updatedAt,
  });

  factory GetCatBreedBody.fromJson(Map<String, dynamic> json) =>
      GetCatBreedBody(
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
