import 'dart:convert';

/*FaqsModel faqsModelFromJson(String str) => FaqsModel.fromJson(json.decode(str));

String faqsModelToJson(FaqsModel data) => json.encode(data.toJson());

class FaqsModel {
  bool? success;
  int? code;
  String? message;
  List<FaqsModelBody>? data;
  Metadata? metadata;
  String? error;

  FaqsModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.metadata,
  });


  FaqsModel.withError(String errorMessage) {
    error = errorMessage;
  }



  factory FaqsModel.fromJson(Map<String, dynamic> json) => FaqsModel(
    success: json["success"],
    code: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<FaqsModelBody>.from(json["data"]!.map((x) => FaqsModelBody.fromJson(x))),
    metadata: json["_metadata"] == null ? null : Metadata.fromJson(json["_metadata"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status": code,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "_metadata": metadata?.toJson(),
  };
}

class FaqsModelBody {
  int? id;
  String? question;
  String? answer;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;

  //extra
  bool isExpanded = false;

  FaqsModelBody({
    this.id,
    this.question,
    this.answer,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory FaqsModelBody.fromJson(Map<String, dynamic> json) => FaqsModelBody(
    id: json["id"],
    question: json["question"],
    answer: json["answer"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "status": status,
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
}*/

FaqsModel faqsModelFromJson(String str) => FaqsModel.fromJson(json.decode(str));

String faqsModelToJson(FaqsModel data) => json.encode(data.toJson());

class FaqsModel {
  bool? success;
  int? code;
  String? message;
  List<FaqsModelBody>? data;
  Metadata? metadata;

  FaqsModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.metadata,
  });

  factory FaqsModel.fromJson(Map<String, dynamic> json) => FaqsModel(
        success: json["success"],
        code: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<FaqsModelBody>.from(
                json["data"]!.map((x) => FaqsModelBody.fromJson(x))),
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

class FaqsModelBody {
  int? id;
  String? question;
  String? answer;
  String? questionFr;
  String? answerFr;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;

  //extra
  bool isExpanded = false;

  FaqsModelBody({
    this.id,
    this.question,
    this.answer,
    this.questionFr,
    this.answerFr,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory FaqsModelBody.fromJson(Map<String, dynamic> json) => FaqsModelBody(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
        questionFr: json["questionFr"],
        answerFr: json["answerFr"],
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
        "question": question,
        "answer": answer,
        "questionFr": questionFr,
        "answerFr": answerFr,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "status": status,
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
