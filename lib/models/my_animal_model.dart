import 'dart:convert';

MyAnimalModel myAnimalModelFromJson(String str) =>
    MyAnimalModel.fromJson(json.decode(str));

String myAnimalModelToJson(MyAnimalModel data) => json.encode(data.toJson());

class MyAnimalModel {
  bool? error;
  int? status;
  String? message;
  List<MyAnimalModelBody>? data;
  Metadata? metadata;

  MyAnimalModel({
    this.error,
    this.status,
    this.message,
    this.data,
    this.metadata,
  });

  factory MyAnimalModel.fromJson(Map<String, dynamic> json) => MyAnimalModel(
        error: json["error"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<MyAnimalModelBody>.from(
                json["data"]!.map((x) => MyAnimalModelBody.fromJson(x))),
        metadata: json["_metadata"] == null
            ? null
            : Metadata.fromJson(json["_metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "_metadata": metadata?.toJson(),
      };
}

class MyAnimalModelBody {
  int? age;
  int? weight;

  int? id;
  String? name;
  String? type;
  DateTime? dob;
  List<String>? images;
  String? breed;
  String? gender;
  String? sterilized;
  String? specices;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;
  int? userId;

  MyAnimalModelBody({
    this.age,
    this.weight,
    this.id,
    this.name,
    this.type,
    this.dob,
    this.images,
    this.breed,
    this.gender,
    this.sterilized,
    this.specices,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.userId,
  });

  factory MyAnimalModelBody.fromJson(Map<String, dynamic> json) =>
      MyAnimalModelBody(
        age: json["age"],
        weight: json["weight"],
        id: json["id"],
        name: json["name"],
        type: json["type"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"].map((x) => x)),
        breed: json["breed"],
        gender: json["gender"],
        sterilized: json["sterilized"],
        specices: json["specices"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        status: json["status"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "age": age,
        "weight": weight,
        "id": id,
        "name": name,
        "type": type,
        "dob": dob == null ? null : "${dob!.toIso8601String()}",
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "breed": breed,
        "gender": gender,
        "sterilized": sterilized,
        "specices": specices,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "status": status,
        "userId": userId,
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
