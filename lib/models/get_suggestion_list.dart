// To parse this JSON data, do
//
//     final getSuggestionList = getSuggestionListFromJson(jsonString);

import 'dart:convert';

GetSuggestionList getSuggestionListFromJson(String str) =>
    GetSuggestionList.fromJson(json.decode(str));

String getSuggestionListToJson(GetSuggestionList data) =>
    json.encode(data.toJson());

class GetSuggestionList {
  bool? success;
  int? code;
  String? message;
  List<GetSuggestionBody>? data;
  Metadata? metadata;

  GetSuggestionList({
    this.success,
    this.code,
    this.message,
    this.data,
    this.metadata,
  });

  factory GetSuggestionList.fromJson(Map<String, dynamic> json) =>
      GetSuggestionList(
        success: json["success"],
        code: json["status"],
        message: json["message"],
        data: List<GetSuggestionBody>.from(
            json["data"].map((x) => GetSuggestionBody.fromJson(x))),
        metadata: Metadata.fromJson(json["_metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status": code,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "_metadata": metadata?.toJson(),
      };
}

class GetSuggestionBody {
  int id;
  String name;
  String? profilePicture;
  String email;
  int isFollowing;
  int totalAnimals;
  int matchScore;

  GetSuggestionBody({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.email,
    required this.isFollowing,
    required this.totalAnimals,
    required this.matchScore,
  });

  factory GetSuggestionBody.fromJson(Map<String, dynamic> json) =>
      GetSuggestionBody(
        id: json["id"],
        name: json["name"],
        profilePicture: json["profile_picture"],
        email: json["email"],
        isFollowing: json["isFollowing"],
        totalAnimals: json["totalAnimals"],
        matchScore: json["matchScore"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profile_picture": profilePicture,
        "email": email,
        "isFollowing": isFollowing,
        "totalAnimals": totalAnimals,
        "matchScore": matchScore,
      };
}

class Metadata {
  int totalRecords;
  int totalPages;

  Metadata({
    required this.totalRecords,
    required this.totalPages,
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
