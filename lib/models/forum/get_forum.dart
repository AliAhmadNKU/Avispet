// To parse this JSON data, do
//
//     final getForum = getForumFromJson(jsonString);

import 'dart:convert';

GetForum getForumFromJson(String str) => GetForum.fromJson(json.decode(str));

String getForumToJson(GetForum data) => json.encode(data.toJson());

class GetForum {
  bool? success;
  int? code;
  String? message;
  List<GetForumBody>? data;
  Metadata? metadata;

  GetForum({
    this.success,
    this.code,
    this.message,
    this.data,
    this.metadata,
  });

  factory GetForum.fromJson(Map<String, dynamic> json) => GetForum(
        success: json["success"],
        code: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<GetForumBody>.from(
                json["data"]!.map((x) => GetForumBody.fromJson(x))),
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

class GetForumBody {
  int? id;
  String? title;
  dynamic titleFr;
  dynamic description;
  dynamic descriptionFr;
  DateTime? createdAt;
  DateTime? updatedAt;
  Status? status;
  int? dogBreedId;
  DogBreed? dogBreed;
  int? totalTopics;
  int? totalReplies;

  GetForumBody({
    this.id,
    this.title,
    this.titleFr,
    this.description,
    this.descriptionFr,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.dogBreedId,
    this.dogBreed,
    this.totalTopics,
    this.totalReplies,
  });

  factory GetForumBody.fromJson(Map<String, dynamic> json) => GetForumBody(
        id: json["id"],
        title: json["title"],
        titleFr: json["titleFr"],
        description: json["description"],
        descriptionFr: json["descriptionFr"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        status: statusValues.map[json["status"]]!,
        dogBreedId: json["dogBreedId"],
        dogBreed: json["dog_breed"] == null
            ? null
            : DogBreed.fromJson(json["dog_breed"]),
        totalTopics: json["totalTopics"],
        totalReplies: json["totalReplies"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "titleFr": titleFr,
        "description": description,
        "descriptionFr": descriptionFr,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "status": statusValues.reverse[status],
        "dogBreedId": dogBreedId,
        "dog_breed": dogBreed?.toJson(),
        "totalTopics": totalTopics,
        "totalReplies": totalReplies,
      };
}

class DogBreed {
  int? id;
  String? name;
  String? icon;

  DogBreed({
    this.id,
    this.name,
    this.icon,
  });

  factory DogBreed.fromJson(Map<String, dynamic> json) => DogBreed(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
      };
}

enum Status { ACTIVE }

final statusValues = EnumValues({"Active": Status.ACTIVE});

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
