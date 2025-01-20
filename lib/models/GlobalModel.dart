class GlobalModel {
  bool? success;
  int? code;
  String? message;
  List<Data>? data;

  GlobalModel({this.success, this.code, this.message, this.data});

  GlobalModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? type;
  String? metaKey;
  String? metaValue;

  Data({this.id, this.type, this.metaKey, this.metaValue});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    metaKey = json['metaKey'];
    metaValue = json['metaValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['metaKey'] = this.metaKey;
    data['metaValue'] = this.metaValue;
    return data;
  }
}
