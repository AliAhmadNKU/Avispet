// To parse this JSON data, do
//
//     final getNotification = getNotificationFromJson(jsonString);

import 'dart:convert';

GetNotification getNotificationFromJson(String str) =>
    GetNotification.fromJson(json.decode(str));

String getNotificationToJson(GetNotification data) =>
    json.encode(data.toJson());

class GetNotification {
  bool? success;
  int? code;
  String? message;
  List<Datum>? data;
  Metadata? metadata;
  String? error;

  GetNotification({
    this.success,
    this.code,
    this.message,
    this.data,
    this.metadata,
  });

  GetNotification.withError(String errorMessage) {
    error = errorMessage;
  }

  factory GetNotification.fromJson(Map<String, dynamic> json) =>
      GetNotification(
        success: json["success"],
        code: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
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

class Datum {
  String? createdAt;
  int? id;
  int? tableId;
  String? type;
  String? message;
  Payload? payload;
  int? isRead;
  DateTime? updatedAt;
  int? senderId;
  int? receiverId;
  SenderRef? senderRef;

  Datum({
    this.createdAt,
    this.id,
    this.tableId,
    this.type,
    this.message,
    this.payload,
    this.isRead,
    this.updatedAt,
    this.senderId,
    this.receiverId,
    this.senderRef,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        createdAt: json["createdAt"],
        id: json["id"],
        tableId: json["tableId"],
        type: json["type"],
        message: json["message"],
        payload:
            json["payload"] == null ? null : Payload.fromJson(json["payload"]),
        isRead: json["isRead"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        senderRef: json["senderRef"] == null
            ? null
            : SenderRef.fromJson(json["senderRef"]),
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt,
        "id": id,
        "tableId": tableId,
        "type": type,
        "message": message,
        "payload": payload?.toJson(),
        "isRead": isRead,
        "updatedAt": updatedAt?.toIso8601String(),
        "senderId": senderId,
        "receiverId": receiverId,
        "senderRef": senderRef?.toJson(),
      };
}

class Payload {
  int? id;
  String? referenceId;
  String? title;
  String? description;
  int? sendEmail;
  String? createdAt;
  DateTime? updatedAt;
  String? status;
  int? forumCategoryId;
  int? forumId;
  int? userId;
  String? tagId;
  String? strongPoints;
  String? weakPoints;
  String? qualityOfPoop;
  dynamic appetite;
  String? digestion;
  String? price;
  String? brand;
  String? productName;
  String? weight;
  int? categoryId;
  int? subCategoryId;
  int? animalId;
  String? comment;
  dynamic replyId;
  int? feedId;
  int? senderId;
  int? receiverId;
  int? chatConstantId;
  int? groupId;
  String? message;
  String? mediaUrl;
  int? readStatus;
  int? messageType;
  int? deletedId;
  int? created;
  int? updated;
  String? senderName;
  String? senderImage;
  String? recieverName;
  String? recieverImage;
  int? onApp;

  Payload({
    this.id,
    this.referenceId,
    this.title,
    this.description,
    this.sendEmail,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.forumCategoryId,
    this.forumId,
    this.userId,
    this.tagId,
    this.strongPoints,
    this.weakPoints,
    this.qualityOfPoop,
    this.appetite,
    this.digestion,
    this.price,
    this.brand,
    this.productName,
    this.weight,
    this.categoryId,
    this.subCategoryId,
    this.animalId,
    this.comment,
    this.replyId,
    this.feedId,
    this.senderId,
    this.receiverId,
    this.chatConstantId,
    this.groupId,
    this.message,
    this.mediaUrl,
    this.readStatus,
    this.messageType,
    this.deletedId,
    this.created,
    this.updated,
    this.senderName,
    this.senderImage,
    this.recieverName,
    this.recieverImage,
    this.onApp,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        id: json["id"],
        referenceId: json["referenceId"],
        title: json["title"],
        description: json["description"],
        sendEmail: json["sendEmail"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        status: json["status"],
        forumCategoryId: json["forumCategoryId"],
        forumId: json["forumId"],
        userId: json["userId"],
        tagId: json["tagId"],
        strongPoints: json["strongPoints"],
        weakPoints: json["weakPoints"],
        qualityOfPoop: json["qualityOfPoop"],
        appetite: json["appetite"],
        digestion: json["digestion"],
        price: json["price"],
        brand: json["brand"],
        productName: json["productName"],
        weight: json["weight"],
        categoryId: json["categoryId"],
        subCategoryId: json["subCategoryId"],
        animalId: json["animalId"],
        comment: json["comment"],
        replyId: json["replyId"],
        feedId: json["feedId"],
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        chatConstantId: json["chatConstantId"],
        groupId: json["groupId"],
        message: json["message"],
        mediaUrl: json["mediaUrl"],
        readStatus: json["readStatus"],
        messageType: json["messageType"],
        deletedId: json["deletedId"],
        created: json["created"],
        updated: json["updated"],
        senderName: json["senderName"],
        senderImage: json["senderImage"],
        recieverName: json["recieverName"],
        recieverImage: json["recieverImage"],
        onApp: json["onApp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "referenceId": referenceId,
        "title": title,
        "description": description,
        "sendEmail": sendEmail,
        "createdAt": createdAt,
        "updatedAt": updatedAt?.toIso8601String(),
        "status": status,
        "forumCategoryId": forumCategoryId,
        "forumId": forumId,
        "userId": userId,
        "tagId": tagId,
        "strongPoints": strongPoints,
        "weakPoints": weakPoints,
        "qualityOfPoop": qualityOfPoop,
        "appetite": appetite,
        "digestion": digestion,
        "price": price,
        "brand": brand,
        "productName": productName,
        "weight": weight,
        "categoryId": categoryId,
        "subCategoryId": subCategoryId,
        "animalId": animalId,
        "comment": comment,
        "replyId": replyId,
        "feedId": feedId,
        "senderId": senderId,
        "receiverId": receiverId,
        "chatConstantId": chatConstantId,
        "groupId": groupId,
        "message": message,
        "mediaUrl": mediaUrl,
        "readStatus": readStatus,
        "messageType": messageType,
        "deletedId": deletedId,
        "created": created,
        "updated": updated,
        "senderName": senderName,
        "senderImage": senderImage,
        "recieverName": recieverName,
        "recieverImage": recieverImage,
        "onApp": onApp,
      };
}

class SenderRef {
  int? id;
  String? name;
  String? profilePicture;
  String? userType;

  SenderRef({
    this.id,
    this.name,
    this.profilePicture,
    this.userType,
  });

  factory SenderRef.fromJson(Map<String, dynamic> json) => SenderRef(
        id: json["id"],
        name: json["name"],
        profilePicture: json["profile_picture"],
        userType: json["user_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profile_picture": profilePicture,
        "user_type": userType,
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
