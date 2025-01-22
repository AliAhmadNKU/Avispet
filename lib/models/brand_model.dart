class BrandModel {
  bool? success;
  int? code;
  String? message;
  List<BrandModelBody>? data;
  Metadata? mMetadata;

  BrandModel(
      {this.success, this.code, this.message, this.data, this.mMetadata});

  BrandModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BrandModelBody>[];
      json['data'].forEach((v) {
        data!.add(new BrandModelBody.fromJson(v));
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

class BrandModelBody {
  int? id;
  String? name;
  String? nameFr;
  Null icon;
  String? createdAt;
  String? updatedAt;
  String? status;

  bool isSelect = false;

  BrandModelBody(
      {this.id,
      this.name,
      this.nameFr,
      this.icon,
      this.createdAt,
      this.updatedAt,
      this.status});

  BrandModelBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameFr = json['nameFr'];
    icon = json['icon'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['nameFr'] = this.nameFr;
    data['icon'] = this.icon;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['status'] = this.status;
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
