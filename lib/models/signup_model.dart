class SignUpModel {
  int? status;
  bool? error;
  String? message;
  Data? data;
  Metadata? metadata;

  SignUpModel({this.status, this.error, this.message, this.data, this.metadata});

  SignUpModel.fromJson(Map<String, dynamic> json) {
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
  String? timezone;
  String? socketId;
  String? latitude;
  String? longitude;
  String? deviceToken;
  String? socialId;
  String? socialType;
  String? deviceType;
  int? gamePoints;
  bool? allowPushNotifications;
  String? resetToken;
  String? resetTokenExpiresAt;
  bool? isVerified;
  String? createdAt;
  String? updatedAt;

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
      this.gamePoints,
      this.allowPushNotifications,
      this.resetToken,
      this.resetTokenExpiresAt,
      this.isVerified,
      this.createdAt,
      this.updatedAt});

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
    gamePoints = json['gamePoints'];
    allowPushNotifications = json['allowPushNotifications'];
    resetToken = json['reset_token'];
    resetTokenExpiresAt = json['reset_token_expires_at'];
    isVerified = json['is_verified'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
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
    data['longitude'] = this.longitude;
    data['deviceToken'] = this.deviceToken;
    data['socialId'] = this.socialId;
    data['socialType'] = this.socialType;
    data['deviceType'] = this.deviceType;
    data['gamePoints'] = this.gamePoints;
    data['allowPushNotifications'] = this.allowPushNotifications;
    data['reset_token'] = this.resetToken;
    data['reset_token_expires_at'] = this.resetTokenExpiresAt;
    data['is_verified'] = this.isVerified;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Metadata {
  int? isNew;

  Metadata({this.isNew});

  Metadata.fromJson(Map<String, dynamic> json) {
    isNew = json['isNew'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isNew'] = this.isNew;
    return data;
  }
}
