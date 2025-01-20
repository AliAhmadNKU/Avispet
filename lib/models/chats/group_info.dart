
import 'dart:convert';

GroupInfo groupInfoFromJson(String str) => GroupInfo.fromJson(json.decode(str));

String groupInfoToJson(GroupInfo data) => json.encode(data.toJson());

class GroupInfo {
  int? id;
  int? userId;
  String? groupName;
  String? groupIcon;
  int? createdAt;
  List<GroupInfoMember>? members;

  GroupInfo({
    this.id,
    this.userId,
    this.groupName,
    this.groupIcon,
    this.createdAt,
    this.members,
  });

  factory GroupInfo.fromJson(Map<String, dynamic> json) => GroupInfo(
    id: json["id"],
    userId: json["userId"],
    groupName: json["groupName"],
    groupIcon: json["groupIcon"],
    createdAt: json["createdAt"],
    members: json["members"] == null ? [] : List<GroupInfoMember>.from(json["members"]!.map((x) => GroupInfoMember.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "groupName": groupName,
    "groupIcon": groupIcon,
    "createdAt": createdAt,
    "members": members == null ? [] : List<dynamic>.from(members!.map((x) => x.toJson())),
  };
}

class GroupInfoMember {
  int? id;
  int? groupId;
  int? userId;
  int? isAdmin;
  int? createdAt;
  int? updatedAt;
  int? isOnline;
  UserDetails? userDetails;

  GroupInfoMember({
    this.id,
    this.groupId,
    this.userId,
    this.isAdmin,
    this.createdAt,
    this.updatedAt,
    this.isOnline,
    this.userDetails,
  });

  factory GroupInfoMember.fromJson(Map<String, dynamic> json) => GroupInfoMember(
    id: json["id"],
    groupId: json["groupId"],
    userId: json["userId"],
    isAdmin: json["isAdmin"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    isOnline: json["isOnline"],
    userDetails: json["userDetails"] == null ? null : UserDetails.fromJson(json["userDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "groupId": groupId,
    "userId": userId,
    "isAdmin": isAdmin,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "isOnline": isOnline,
    "userDetails": userDetails?.toJson(),
  };
}

class UserDetails {
  int? id;
  String? firstName;
  String? lastName;
  String? profilePicture;

  UserDetails({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePicture,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    profilePicture: json["profile_picture"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "profile_picture": profilePicture,
  };
}
