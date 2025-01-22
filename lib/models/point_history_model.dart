class PointHistoryModel {
  bool? success;
  int? code;
  String? message;
  List<Data>? data;
  Metadata? mMetadata;

  PointHistoryModel(
      {this.success, this.code, this.message, this.data, this.mMetadata});

  PointHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    mMetadata = json['_metadata'] != null
        ? new Metadata.fromJson(json['_metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.mMetadata != null) {
      data['_metadata'] = this.mMetadata!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? type;
  int? pointsEarned;
  int? referenceId;
  String? createdAt;
  String? updatedAt;
  int? userId;
  String? text;

  Data(
      {this.id,
      this.type,
      this.pointsEarned,
      this.referenceId,
      this.createdAt,
      this.updatedAt,
      this.userId,
      this.text});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    pointsEarned = json['pointsEarned'];
    referenceId = json['referenceId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['pointsEarned'] = this.pointsEarned;
    data['referenceId'] = this.referenceId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    data['text'] = this.text;
    return data;
  }
}

class Metadata {
  int? totalRecords;
  int? totalPages;

  Metadata({this.totalRecords, this.totalPages});

  Metadata.fromJson(Map<String, dynamic> json) {
    totalRecords = json['totalRecords'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalRecords'] = this.totalRecords;
    data['totalPages'] = this.totalPages;
    return data;
  }
}
