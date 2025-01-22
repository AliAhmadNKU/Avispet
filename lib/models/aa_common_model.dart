import 'dart:convert';

CommonModel commonModelFromJson(String str) =>
    CommonModel.fromJson(json.decode(str));

String commonModelToJson(CommonModel data) => json.encode(data.toJson());

class CommonModel {
  bool? success;
  int? code;
  String? message;

  CommonModel({
    this.success,
    this.code,
    this.message,
  });

  factory CommonModel.fromJson(Map<String, dynamic> json) => CommonModel(
        success: json["error"],
        code: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": success,
        "status": code,
        "message": message,
      };
}
