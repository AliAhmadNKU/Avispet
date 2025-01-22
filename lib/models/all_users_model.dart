class AllUsers {
  bool? success;
  int? code;
  String? message;
  List<Data>? data;
  Metadata? mMetadata;

  AllUsers({this.success, this.code, this.message, this.data, this.mMetadata});

  AllUsers.fromJson(Map<String, dynamic> json) {
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
  int? age;
  int? id;
  String? name;
  String? firstName;
  String? lastName;
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
  var dob;
  var profession;
  String? gender;
  var phoneNumber;
  var biography;
  String? isEmailVerified;
  String? userType;
  int? locationOn;
  String? timezone;
  int? allowPushNotifications;
  var verificationCode;
  String? deviceToken;
  String? deviceType;
  String? createdAt;
  String? updatedAt;
  String? accountStatus;
  var interestId;
  var interestBackdropId;
  String? pseudo;
  String? socketId;
  int? isOnline;

  Data(
      {this.age,
      this.id,
      this.name,
      this.firstName,
      this.lastName,
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
      this.dob,
      this.profession,
      this.gender,
      this.phoneNumber,
      this.biography,
      this.isEmailVerified,
      this.userType,
      this.locationOn,
      this.timezone,
      this.allowPushNotifications,
      this.verificationCode,
      this.deviceToken,
      this.deviceType,
      this.createdAt,
      this.updatedAt,
      this.accountStatus,
      this.interestId,
      this.interestBackdropId,
      this.pseudo,
      this.socketId,
      this.isOnline});

  Data.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    id = json['id'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    socialId = json['social_id'];
    socialType = json['social_type'];
    profilePicture = json['profile_picture'];
    coverPicture = json['cover_picture'];
    address = json['address'];
    alternativeAddress = json['alternative_address'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    dob = json['dob'];
    profession = json['profession'];
    gender = json['gender'];
    phoneNumber = json['phoneNumber'];
    biography = json['biography'];
    isEmailVerified = json['is_email_verified'];
    userType = json['user_type'];
    locationOn = json['location_on'];
    timezone = json['timezone'];
    allowPushNotifications = json['allow_push_notifications'];
    verificationCode = json['verification_code'];
    deviceToken = json['device_token'];
    deviceType = json['device_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    accountStatus = json['account_status'];
    interestId = json['interestId'];
    interestBackdropId = json['interestBackdropId'];
    pseudo = json['pseudo'];
    socketId = json['socket_id'];
    isOnline = json['is_online'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['id'] = this.id;
    data['name'] = this.name;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['social_id'] = this.socialId;
    data['social_type'] = this.socialType;
    data['profile_picture'] = this.profilePicture;
    data['cover_picture'] = this.coverPicture;
    data['address'] = this.address;
    data['alternative_address'] = this.alternativeAddress;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['dob'] = this.dob;
    data['profession'] = this.profession;
    data['gender'] = this.gender;
    data['phoneNumber'] = this.phoneNumber;
    data['biography'] = this.biography;
    data['is_email_verified'] = this.isEmailVerified;
    data['user_type'] = this.userType;
    data['location_on'] = this.locationOn;
    data['timezone'] = this.timezone;
    data['allow_push_notifications'] = this.allowPushNotifications;
    data['verification_code'] = this.verificationCode;
    data['device_token'] = this.deviceToken;
    data['device_type'] = this.deviceType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['account_status'] = this.accountStatus;
    data['interestId'] = this.interestId;
    data['interestBackdropId'] = this.interestBackdropId;
    data['pseudo'] = this.pseudo;
    data['socket_id'] = this.socketId;
    data['is_online'] = this.isOnline;
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
