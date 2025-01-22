class RankingModel {
  bool? success;
  int? code;
  String? message;
  List<Data>? data;
  Metadata? mMetadata;

  RankingModel(
      {this.success, this.code, this.message, this.data, this.mMetadata});

  RankingModel.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  String? totalPoints;
  User? user;
  int? rank;

  Data({this.userId, this.totalPoints, this.user, this.rank});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    totalPoints = json['totalPoints'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['totalPoints'] = this.totalPoints;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['rank'] = this.rank;
    return data;
  }
}

class User {
  String? name;
  var profilePicture;

  User({this.name, this.profilePicture});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profilePicture = json['profile_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['profile_picture'] = this.profilePicture;
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
