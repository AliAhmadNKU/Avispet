class FollowerUserResponseModel {
  FollowerUserResponseModel({
      num? status, 
      bool? error, 
      String? message, 
      List<FollowerUserModel>? data,
      dynamic metadata,}){
    _status = status;
    _error = error;
    _message = message;
    _data = data;
    _metadata = metadata;
}

  FollowerUserResponseModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(FollowerUserModel.fromJson(v));
      });
    }
    _metadata = json['metadata'];
  }
  num? _status;
  bool? _error;
  String? _message;
  List<FollowerUserModel>? _data;
  dynamic _metadata;
  FollowerUserResponseModel copyWith({  num? status,
  bool? error,
  String? message,
  List<FollowerUserModel>? data,
  dynamic metadata,
}) => FollowerUserResponseModel(  status: status ?? _status,
  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
  metadata: metadata ?? _metadata,
);
  num? get status => _status;
  bool? get error => _error;
  String? get message => _message;
  List<FollowerUserModel>? get data => _data;
  dynamic get metadata => _metadata;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['metadata'] = _metadata;
    return map;
  }

}

class FollowerUserModel {
  FollowerUserModel({
      num? id, 
      num? followerId, 
      num? followingId, 
      String? status, 
      String? createdAt, 
      String? updatedAt,
    FollowerUser? following,
      num? followerCount,}){
    _id = id;
    _followerId = followerId;
    _followingId = followingId;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _following = following;
    _followerCount = followerCount;
}

  FollowerUserModel.fromJson(dynamic json) {
    _id = json['id'];
    _followerId = json['followerId'];
    _followingId = json['followingId'];
    _status = json['status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _following = json['follower'] != null ? FollowerUser.fromJson(json['follower']) : null;
    _followerCount = json['followerCount'];
  }
  num? _id;
  num? _followerId;
  num? _followingId;
  String? _status;
  String? _createdAt;
  String? _updatedAt;
  FollowerUser? _following;
  num? _followerCount;
  FollowerUserModel copyWith({  num? id,
  num? followerId,
  num? followingId,
  String? status,
  String? createdAt,
  String? updatedAt,
    FollowerUser? following,
  num? followerCount,
}) => FollowerUserModel(  id: id ?? _id,
  followerId: followerId ?? _followerId,
  followingId: followingId ?? _followingId,
  status: status ?? _status,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  following: following ?? _following,
  followerCount: followerCount ?? _followerCount,
);
  num? get id => _id;
  num? get followerId => _followerId;
  num? get followingId => _followingId;
  String? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  FollowerUser? get following => _following;
  num? get followerCount => _followerCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['followerId'] = _followerId;
    map['followingId'] = _followingId;
    map['status'] = _status;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_following != null) {
      map['follower'] = _following?.toJson();
    }
    map['followerCount'] = _followerCount;
    return map;
  }

}

class FollowerUser {
  FollowerUser({
      num? id, 
      String? name, 
      String? firstName, 
      String? lastName, 
      dynamic isOnline, 
      String? email, 
      String? phoneNumber, 
      String? pseudo, 
      String? profilePicture, 
      String? coverPicture, 
      String? profession, 
      String? dob, 
      String? age, 
      String? gender, 
      String? city, 
      String? area, 
      String? timezone, 
      dynamic socketId, 
      String? latitude, 
      String? longitude, 
      String? deviceToken, 
      dynamic socialId, 
      dynamic socialType, 
      String? deviceType, 
      dynamic biography, 
      dynamic lastActive, 
      num? gamePoints, 
      bool? allowPushNotifications, 
      String? resetToken, 
      String? resetTokenExpiresAt, 
      bool? isVerified, 
      bool? isActivate, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _name = name;
    _firstName = firstName;
    _lastName = lastName;
    _isOnline = isOnline;
    _email = email;
    _phoneNumber = phoneNumber;
    _pseudo = pseudo;
    _profilePicture = profilePicture;
    _coverPicture = coverPicture;
    _profession = profession;
    _dob = dob;
    _age = age;
    _gender = gender;
    _city = city;
    _area = area;
    _timezone = timezone;
    _socketId = socketId;
    _latitude = latitude;
    _longitude = longitude;
    _deviceToken = deviceToken;
    _socialId = socialId;
    _socialType = socialType;
    _deviceType = deviceType;
    _biography = biography;
    _lastActive = lastActive;
    _gamePoints = gamePoints;
    _allowPushNotifications = allowPushNotifications;
    _resetToken = resetToken;
    _resetTokenExpiresAt = resetTokenExpiresAt;
    _isVerified = isVerified;
    _isActivate = isActivate;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  FollowerUser.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _isOnline = json['is_online'];
    _email = json['email'];
    _phoneNumber = json['phone_number'];
    _pseudo = json['pseudo'];
    _profilePicture = json['profile_picture'];
    _coverPicture = json['coverPicture'];
    _profession = json['profession'];
    _dob = json['dob'];
    _age = json['age'];
    _gender = json['gender'];
    _city = json['city'];
    _area = json['area'];
    _timezone = json['timezone'];
    _socketId = json['socket_id'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _deviceToken = json['deviceToken'];
    _socialId = json['socialId'];
    _socialType = json['socialType'];
    _deviceType = json['deviceType'];
    _biography = json['biography'];
    _lastActive = json['last_active'];
    _gamePoints = json['gamePoints'];
    _allowPushNotifications = json['allowPushNotifications'];
    _resetToken = json['reset_token'];
    _resetTokenExpiresAt = json['reset_token_expires_at'];
    _isVerified = json['is_verified'];
    _isActivate = json['is_activate'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  num? _id;
  String? _name;
  String? _firstName;
  String? _lastName;
  dynamic _isOnline;
  String? _email;
  String? _phoneNumber;
  String? _pseudo;
  String? _profilePicture;
  String? _coverPicture;
  String? _profession;
  String? _dob;
  String? _age;
  String? _gender;
  String? _city;
  String? _area;
  String? _timezone;
  dynamic _socketId;
  String? _latitude;
  String? _longitude;
  String? _deviceToken;
  dynamic _socialId;
  dynamic _socialType;
  String? _deviceType;
  dynamic _biography;
  dynamic _lastActive;
  num? _gamePoints;
  bool? _allowPushNotifications;
  String? _resetToken;
  String? _resetTokenExpiresAt;
  bool? _isVerified;
  bool? _isActivate;
  String? _createdAt;
  String? _updatedAt;
  FollowerUser copyWith({  num? id,
  String? name,
  String? firstName,
  String? lastName,
  dynamic isOnline,
  String? email,
  String? phoneNumber,
  String? pseudo,
  String? profilePicture,
  String? coverPicture,
  String? profession,
  String? dob,
  String? age,
  String? gender,
  String? city,
  String? area,
  String? timezone,
  dynamic socketId,
  String? latitude,
  String? longitude,
  String? deviceToken,
  dynamic socialId,
  dynamic socialType,
  String? deviceType,
  dynamic biography,
  dynamic lastActive,
  num? gamePoints,
  bool? allowPushNotifications,
  String? resetToken,
  String? resetTokenExpiresAt,
  bool? isVerified,
  bool? isActivate,
  String? createdAt,
  String? updatedAt,
}) => FollowerUser(  id: id ?? _id,
  name: name ?? _name,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  isOnline: isOnline ?? _isOnline,
  email: email ?? _email,
  phoneNumber: phoneNumber ?? _phoneNumber,
  pseudo: pseudo ?? _pseudo,
  profilePicture: profilePicture ?? _profilePicture,
  coverPicture: coverPicture ?? _coverPicture,
  profession: profession ?? _profession,
  dob: dob ?? _dob,
  age: age ?? _age,
  gender: gender ?? _gender,
  city: city ?? _city,
  area: area ?? _area,
  timezone: timezone ?? _timezone,
  socketId: socketId ?? _socketId,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
  deviceToken: deviceToken ?? _deviceToken,
  socialId: socialId ?? _socialId,
  socialType: socialType ?? _socialType,
  deviceType: deviceType ?? _deviceType,
  biography: biography ?? _biography,
  lastActive: lastActive ?? _lastActive,
  gamePoints: gamePoints ?? _gamePoints,
  allowPushNotifications: allowPushNotifications ?? _allowPushNotifications,
  resetToken: resetToken ?? _resetToken,
  resetTokenExpiresAt: resetTokenExpiresAt ?? _resetTokenExpiresAt,
  isVerified: isVerified ?? _isVerified,
  isActivate: isActivate ?? _isActivate,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  String? get name => _name;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  dynamic get isOnline => _isOnline;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get pseudo => _pseudo;
  String? get profilePicture => _profilePicture;
  String? get coverPicture => _coverPicture;
  String? get profession => _profession;
  String? get dob => _dob;
  String? get age => _age;
  String? get gender => _gender;
  String? get city => _city;
  String? get area => _area;
  String? get timezone => _timezone;
  dynamic get socketId => _socketId;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get deviceToken => _deviceToken;
  dynamic get socialId => _socialId;
  dynamic get socialType => _socialType;
  String? get deviceType => _deviceType;
  dynamic get biography => _biography;
  dynamic get lastActive => _lastActive;
  num? get gamePoints => _gamePoints;
  bool? get allowPushNotifications => _allowPushNotifications;
  String? get resetToken => _resetToken;
  String? get resetTokenExpiresAt => _resetTokenExpiresAt;
  bool? get isVerified => _isVerified;
  bool? get isActivate => _isActivate;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['is_online'] = _isOnline;
    map['email'] = _email;
    map['phone_number'] = _phoneNumber;
    map['pseudo'] = _pseudo;
    map['profile_picture'] = _profilePicture;
    map['coverPicture'] = _coverPicture;
    map['profession'] = _profession;
    map['dob'] = _dob;
    map['age'] = _age;
    map['gender'] = _gender;
    map['city'] = _city;
    map['area'] = _area;
    map['timezone'] = _timezone;
    map['socket_id'] = _socketId;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['deviceToken'] = _deviceToken;
    map['socialId'] = _socialId;
    map['socialType'] = _socialType;
    map['deviceType'] = _deviceType;
    map['biography'] = _biography;
    map['last_active'] = _lastActive;
    map['gamePoints'] = _gamePoints;
    map['allowPushNotifications'] = _allowPushNotifications;
    map['reset_token'] = _resetToken;
    map['reset_token_expires_at'] = _resetTokenExpiresAt;
    map['is_verified'] = _isVerified;
    map['is_activate'] = _isActivate;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}