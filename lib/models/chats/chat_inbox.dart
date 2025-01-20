
import 'dart:convert';

List<ChatInbox> chatInboxFromJson(String str) => List<ChatInbox>.from(json.decode(str).map((x) => ChatInbox.fromJson(x)));

String chatInboxToJson(List<ChatInbox> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatInbox {
  int? id;
  int? senderId;
  int? receiverId;
  int? requestId;
  int? groupId;
  int? lastMessageId;
  int? deletedId;
  int? created;
  int? updated;
  int? userId;
  String? lastMessage;
  String? name;
  int? onlineStatus;
  String? lastOnlineTime;
  String? userImage;
  String? senderName;
  int? createdAt;
  int? messageType;
  int? lastSenderId;
  String? mediaUrl;
  int? unreadcount;
  int? onApp;
  int? isBlocked;
  String? theme;
  GroupInfo? groupInfo;

  ChatInbox({
    this.id,
    this.senderId,
    this.receiverId,
    this.requestId,
    this.groupId,
    this.lastMessageId,
    this.deletedId,
    this.created,
    this.updated,
    this.userId,
    this.lastMessage,
    this.name,
    this.onlineStatus,
    this.lastOnlineTime,
    this.userImage,
    this.senderName,
    this.createdAt,
    this.messageType,
    this.lastSenderId,
    this.mediaUrl,
    this.unreadcount,
    this.onApp,
    this.isBlocked,
    this.theme,
    this.groupInfo,
  });

  factory ChatInbox.fromJson(Map<String, dynamic> json) => ChatInbox(
    id: json["id"],
    senderId: json["senderId"],
    receiverId: json["receiverId"],
    requestId: json["requestId"],
    groupId: json["groupId"],
    lastMessageId: json["lastMessageId"],
    deletedId: json["deletedId"],
    created: json["created"],
    updated: json["updated"],
    userId: json["user_id"],
    lastMessage: json["lastMessage"],
    name: json["name"],
    onlineStatus: json["online_status"],
    lastOnlineTime: json["lastOnlineTime"],
    userImage: json["userImage"],
    senderName: json["senderName"],
    createdAt: json["created_at"],
    messageType: json["messageType"],
    lastSenderId: json["lastSenderId"],
    mediaUrl: json["mediaUrl"],
    unreadcount: json["unreadcount"],
    onApp: json["onApp"],
    isBlocked: json["isBlocked"],
    theme: json["theme"],
    groupInfo: json["groupInfo"] == null ? null : GroupInfo.fromJson(json["groupInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "senderId": senderId,
    "receiverId": receiverId,
    "requestId": requestId,
    "groupId": groupId,
    "lastMessageId": lastMessageId,
    "deletedId": deletedId,
    "created": created,
    "updated": updated,
    "user_id": userId,
    "lastMessage": lastMessage,
    "name": name,
    "online_status": onlineStatus,
    "lastOnlineTime": lastOnlineTime,
    "userImage": userImage,
    "senderName": senderName,
    "created_at": createdAt,
    "messageType": messageType,
    "lastSenderId": lastSenderId,
    "mediaUrl": mediaUrl,
    "unreadcount": unreadcount,
    "onApp": onApp,
    "isBlocked": isBlocked,
    "theme": theme,
    "groupInfo": groupInfo?.toJson(),
  };
}

class GroupInfo {
  int? id;
  int? userId;
  String? groupName;
  String? groupIcon;
  int? createdAt;
  String? theme;
  List<Members>? members;

  GroupInfo(
      {this.id,
        this.userId,
        this.groupName,
        this.groupIcon,
        this.createdAt,
        this.theme,
        this.members});

  GroupInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    groupName = json['groupName'];
    groupIcon = json['groupIcon'];
    createdAt = json['createdAt'];
    theme = json['theme'];
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(new Members.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['groupName'] = this.groupName;
    data['groupIcon'] = this.groupIcon;
    data['createdAt'] = this.createdAt;
    data['theme'] = this.theme;
    if (this.members != null) {
      data['members'] = this.members!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Members {
  int? id;
  int? groupId;
  int? userId;
  int? isAdmin;
  int? createdAt;
  int? updatedAt;
  int? isOnline;
  int? isBlocked;
  UserDetails? userDetails;

  Members(
      {this.id,
        this.groupId,
        this.userId,
        this.isAdmin,
        this.createdAt,
        this.updatedAt,
        this.isOnline,
        this.isBlocked,
        this.userDetails});

  Members.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupId = json['groupId'];
    userId = json['userId'];
    isAdmin = json['isAdmin'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isOnline = json['isOnline'];
    isBlocked = json['isBlocked'];
    userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['groupId'] = this.groupId;
    data['userId'] = this.userId;
    data['isAdmin'] = this.isAdmin;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['isOnline'] = this.isOnline;
    data['isBlocked'] = this.isBlocked;
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  int? id;
  String? firstName;
  String? lastName;
  String? profilePicture;

  UserDetails({this.id, this.firstName, this.lastName, this.profilePicture});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePicture = json['profile_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_picture'] = this.profilePicture;
    return data;
  }
}
