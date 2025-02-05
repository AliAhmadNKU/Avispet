/*
class GetProfileModel {
  bool? error;
  int? code;
  String? message;
  Data? data;

  GetProfileModel({this.error, this.code, this.message, this.data});

  GetProfileModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    code = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['status'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? age;
  int? id;
  String? token;
  String? firstName;
  String? lastName;
  String? name;
  String? email;
  var socialId;
  int? socialType;
  String? profilePicture;
  var coverPicture;
  var address;
  var alternativeAddress;
  var city;
  var state;
  var pincode;
  String? latitude;
  String? longitude;
  var profession;
  var dob;
  String? gender;
  var phoneNumber;
  String? biography;
  String? isEmailVerified;
  String? userType;
  int? allowPushNotifications;
  String? timezone;
  var verificationCode;
  String? deviceToken;
  String? deviceType;
  String? createdAt;
  String? updatedAt;
  String? socketId;
  int? isOnline;
  int? gamePoints;
  int? deletePasscode;
  String? accountStatus;
  String? pseudo;
  int? unreadNotificationCount;
  int? unreadMessageCount;
  int? animalsCount;
  int? hasFollowed;
  int? reviewsSubmitted;
  int? questionsFiled;
  int? savedPosts;
  int? answersSubmitted;
  UserLevel? userLevel;
  int? userRanking;

  Data(
      {this.age,
        this.id,
        this.token,
        this.firstName,
        this.lastName,
        this.name,
        this.email,
        this.socialId,
        this.socialType,
        this.profilePicture,
        this.coverPicture,
        this.address,
        this.alternativeAddress,
        this.city,
        this.state,
        this.pincode,
        this.latitude,
        this.longitude,
        this.profession,
        this.dob,
        this.gender,
        this.phoneNumber,
        this.biography,
        this.isEmailVerified,
        this.userType,
        this.allowPushNotifications,
        this.timezone,
        this.verificationCode,
        this.deviceToken,
        this.deviceType,
        this.createdAt,
        this.updatedAt,
        this.socketId,
        this.isOnline,
        this.gamePoints,
        this.deletePasscode,
        this.accountStatus,
        this.pseudo,
        this.unreadNotificationCount,
        this.unreadMessageCount,
        this.animalsCount,
        this.hasFollowed,
        this.reviewsSubmitted,
        this.questionsFiled,
        this.savedPosts,
        this.answersSubmitted,
        this.userLevel,
        this.userRanking});

  Data.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    id = json['id'];
    token = json['token'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    name = json['name'];
    email = json['email'];
    socialId = json['socialId'];
    socialType = json['socialType'];
    profilePicture = json['profilePicture'];
    coverPicture = json['coverPicture'];
    address = json['address'];
    alternativeAddress = json['alternativeAddress'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    profession = json['profession'];
    dob = json['dob'];
    gender = json['gender'];
    phoneNumber = json['phoneNumber'];
    biography = json['biography'];
    isEmailVerified = json['isEmailVerified'];
    userType = json['userType'];
    allowPushNotifications = json['allowPushNotifications'];
    timezone = json['timezone'];
    verificationCode = json['verificationCode'];
    deviceToken = json['deviceToken'];
    deviceType = json['deviceType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    socketId = json['socket_id'];
    isOnline = json['isOnline'];
    gamePoints = json['gamePoints'];
    deletePasscode = json['delete_passcode'];
    accountStatus = json['accountStatus'];
    pseudo = json['pseudo'];
    unreadNotificationCount = json['unreadNotificationCount'];
    unreadMessageCount = json['unreadMessageCount'];
    animalsCount = json['animalsCount'];
    hasFollowed = json['hasFollowed'];
    reviewsSubmitted = json['reviewsSubmitted'];
    questionsFiled = json['questionsFiled'];
    savedPosts = json['savedPosts'];
    answersSubmitted = json['answersSubmitted'];
    userLevel = json['userLevel'] != null
        ? new UserLevel.fromJson(json['userLevel'])
        : null;
    userRanking = json['userRanking'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['id'] = this.id;
    data['token'] = this.token;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['name'] = this.name;
    data['email'] = this.email;
    data['socialId'] = this.socialId;
    data['socialType'] = this.socialType;
    data['profilePicture'] = this.profilePicture;
    data['coverPicture'] = this.coverPicture;
    data['address'] = this.address;
    data['alternativeAddress'] = this.alternativeAddress;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['profession'] = this.profession;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['phoneNumber'] = this.phoneNumber;
    data['biography'] = this.biography;
    data['isEmailVerified'] = this.isEmailVerified;
    data['userType'] = this.userType;
    data['allowPushNotifications'] = this.allowPushNotifications;
    data['timezone'] = this.timezone;
    data['verificationCode'] = this.verificationCode;
    data['deviceToken'] = this.deviceToken;
    data['deviceType'] = this.deviceType;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['socket_id'] = this.socketId;
    data['isOnline'] = this.isOnline;
    data['gamePoints'] = this.gamePoints;
    data['delete_passcode'] = this.deletePasscode;
    data['accountStatus'] = this.accountStatus;
    data['pseudo'] = this.pseudo;
    data['unreadNotificationCount'] = this.unreadNotificationCount;
    data['unreadMessageCount'] = this.unreadMessageCount;
    data['animalsCount'] = this.animalsCount;
    data['hasFollowed'] = this.hasFollowed;
    data['reviewsSubmitted'] = this.reviewsSubmitted;
    data['questionsFiled'] = this.questionsFiled;
    data['savedPosts'] = this.savedPosts;
    data['answersSubmitted'] = this.answersSubmitted;
    if (this.userLevel != null) {
      data['userLevel'] = this.userLevel!.toJson();
    }
    data['userRanking'] = this.userRanking;
    return data;
  }
}

class UserLevel {
  String? name;
  String? nameFr;
  String? minPoints;
  String? maxPoints;

  UserLevel({this.name, this.nameFr, this.minPoints, this.maxPoints});

  UserLevel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameFr = json['nameFr'];
    minPoints = json['minPoints'];
    maxPoints = json['maxPoints'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['nameFr'] = this.nameFr;
    data['minPoints'] = this.minPoints;
    data['maxPoints'] = this.maxPoints;
    return data;
  }
}

*/

// To parse this JSON data, do
//
//     final getProfileModel = getProfileModelFromJson(jsonString);

import 'dart:convert';

class GetProfileModel {
  int? status;
  bool? error;
  String? message;
  Data? data;
  Metadata? metadata;

  GetProfileModel(
      {this.status, this.error, this.message, this.data, this.metadata});

  GetProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? firstName;
  String? lastName;
  bool? isOnline;
  String? email;
  String? phoneNumber;
  String? pseudo;
  String? profilePicture;
  String? coverPicture;
  String? profession;
  String? dob;
  String? age;
  String? gender;
  String? city;
  String? area;
  String? biography;
  String? timezone;
  dynamic socketId;
  String? latitude;
  String? longitude;
  String? deviceToken;
  dynamic socialId;
  dynamic socialType;
  String? deviceType;
  dynamic lastActive;
  int? gamePoints;
  bool? allowPushNotifications;
  dynamic resetToken;
  dynamic resetTokenExpiresAt;
  bool? isVerified;
  bool? isActivate;
  String? createdAt;
  String? updatedAt;
  Counts? counts;

  Data(
      {this.id,
      this.name,
      this.firstName,
      this.lastName,
      this.isOnline,
      this.email,
      this.phoneNumber,
      this.pseudo,
      this.profilePicture,
      this.coverPicture,
      this.profession,
      this.dob,
      this.age,
      this.gender,
      this.city,
      this.area,
      this.timezone,
      this.socketId,
      this.latitude,
      this.longitude,
      this.deviceToken,
      this.socialId,
      this.socialType,
      this.deviceType,
      this.lastActive,
      this.gamePoints,
        this.biography,
      this.allowPushNotifications,
      this.resetToken,
      this.resetTokenExpiresAt,
      this.isVerified,
      this.isActivate,
      this.createdAt,
      this.updatedAt,
      this.counts});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    isOnline = json['is_online'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    pseudo = json['pseudo'];
    profilePicture = json['profile_picture'];
    coverPicture = json['coverPicture'];
    profession = json['profession'];
    dob = json['dob'];
    age = json['age'];
    biography = json['biography'];
    gender = json['gender'];
    city = json['city'];
    area = json['area'];
    timezone = json['timezone'];
    socketId = json['socket_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    deviceToken = json['deviceToken'];
    socialId = json['socialId'];
    socialType = json['socialType'];
    deviceType = json['deviceType'];
    lastActive = json['last_active'];
    gamePoints = json['gamePoints'];
    allowPushNotifications = json['allowPushNotifications'];
    resetToken = json['reset_token'] != null  ? json['reset_token'] : '' ;
    resetTokenExpiresAt = json['reset_token_expires_at'];
    isVerified = json['is_verified'];
    isActivate = json['is_activate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    counts =
        json['counts'] != null ? new Counts.fromJson(json['counts']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['is_online'] = this.isOnline;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['pseudo'] = this.pseudo;
    data['profile_picture'] = this.profilePicture;
    data['coverPicture'] = this.coverPicture;
    data['profession'] = this.profession;
    data['dob'] = this.dob;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['city'] = this.city;
    data['area'] = this.area;
    data['timezone'] = this.timezone;
    data['socket_id'] = this.socketId;
    data['latitude'] = this.latitude;
    data['biography'] = this.biography;
    data['longitude'] = this.longitude;
    data['deviceToken'] = this.deviceToken;
    data['socialId'] = this.socialId;
    data['socialType'] = this.socialType;
    data['deviceType'] = this.deviceType;
    data['last_active'] = this.lastActive;
    data['gamePoints'] = this.gamePoints;
    data['allowPushNotifications'] = this.allowPushNotifications;
    data['reset_token'] = this.resetToken;
    data['reset_token_expires_at'] = this.resetTokenExpiresAt;
    data['is_verified'] = this.isVerified;
    data['is_activate'] = this.isActivate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.counts != null) {
      data['counts'] = this.counts!.toJson();
    }
    return data;
  }
}

class Counts {
  int? followerCount;
  int? followingCount;
  int? notificationCount;
  int? forumSubmissionCount;
  int? postCount;
  int? postReviewCount;

  Counts(
      {this.followerCount,
      this.followingCount,
      this.notificationCount,
      this.forumSubmissionCount,
      this.postCount,
      this.postReviewCount});

  Counts.fromJson(Map<String, dynamic> json) {
    followerCount = json['followerCount'];
    followingCount = json['followingCount'];
    notificationCount = json['notificationCount'];
    forumSubmissionCount = json['forumSubmissionCount'];
    postCount = json['postCount'];
    postReviewCount = json['postReviewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['followerCount'] = this.followerCount;
    data['followingCount'] = this.followingCount;
    data['notificationCount'] = this.notificationCount;
    data['forumSubmissionCount'] = this.forumSubmissionCount;
    data['postCount'] = this.postCount;
    data['postReviewCount'] = this.postReviewCount;
    return data;
  }
}

class Metadata {
  Metadata();

  Metadata.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
