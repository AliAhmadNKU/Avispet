class FollowingSuggestionsResponseModel {
  FollowingSuggestionsResponseModel({
      num? status, 
      bool? error, 
      String? message, 
      List<FollowingSuggestionsModel>? data,
      dynamic metadata,}){
    _status = status;
    _error = error;
    _message = message;
    _data = data;
    _metadata = metadata;
}

  FollowingSuggestionsResponseModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(FollowingSuggestionsModel.fromJson(v));
      });
    }
    _metadata = json['metadata'];
  }
  num? _status;
  bool? _error;
  String? _message;
  List<FollowingSuggestionsModel>? _data;
  dynamic _metadata;
FollowingSuggestionsResponseModel copyWith({  num? status,
  bool? error,
  String? message,
  List<FollowingSuggestionsModel>? data,
  dynamic metadata,
}) => FollowingSuggestionsResponseModel(  status: status ?? _status,
  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
  metadata: metadata ?? _metadata,
);
  num? get status => _status;
  bool? get error => _error;
  String? get message => _message;
  List<FollowingSuggestionsModel>? get data => _data;
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

class FollowingSuggestionsModel {
  FollowingSuggestionsModel({
      num? id, 
      String? email, 
      String? name, 
      String? createdAt, 
      String? area, 
      String? city, 
      bool? isVerified, 
      String? phoneNumber, 
      String? updatedAt, 
      String? pseudo, 
      dynamic resetToken, 
      dynamic resetTokenExpiresAt, 
      String? deviceToken, 
      String? deviceType, 
      String? latitude, 
      String? longitude, 
      dynamic socialId, 
      dynamic socialType, 
      String? password, 
      num? gamePoints, 
      String? firstName, 
      dynamic isOnline, 
      String? lastName, 
      dynamic profilePicture, 
      dynamic age, 
      bool? allowPushNotifications, 
      dynamic coverPicture, 
      dynamic dob, 
      dynamic gender, 
      dynamic profession, 
      dynamic socketId, 
      String? timezone, 
      dynamic lastActive, 
      dynamic biography, 
      bool? isActivate,}){
    _id = id;
    _email = email;
    _name = name;
    _createdAt = createdAt;
    _area = area;
    _city = city;
    _isVerified = isVerified;
    _phoneNumber = phoneNumber;
    _updatedAt = updatedAt;
    _pseudo = pseudo;
    _resetToken = resetToken;
    _resetTokenExpiresAt = resetTokenExpiresAt;
    _deviceToken = deviceToken;
    _deviceType = deviceType;
    _latitude = latitude;
    _longitude = longitude;
    _socialId = socialId;
    _socialType = socialType;
    _password = password;
    _gamePoints = gamePoints;
    _firstName = firstName;
    _isOnline = isOnline;
    _lastName = lastName;
    _profilePicture = profilePicture;
    _age = age;
    _allowPushNotifications = allowPushNotifications;
    _coverPicture = coverPicture;
    _dob = dob;
    _gender = gender;
    _profession = profession;
    _socketId = socketId;
    _timezone = timezone;
    _lastActive = lastActive;
    _biography = biography;
    _isActivate = isActivate;
}

  FollowingSuggestionsModel.fromJson(dynamic json) {
    _id = json['id'];
    _email = json['email'];
    _name = json['name'];
    _createdAt = json['createdAt'];
    _area = json['area'];
    _city = json['city'];
    _isVerified = json['is_verified'];
    _phoneNumber = json['phone_number'];
    _updatedAt = json['updatedAt'];
    _pseudo = json['pseudo'];
    _resetToken = json['reset_token'];
    _resetTokenExpiresAt = json['reset_token_expires_at'];
    _deviceToken = json['deviceToken'];
    _deviceType = json['deviceType'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _socialId = json['socialId'];
    _socialType = json['socialType'];
    _password = json['password'];
    _gamePoints = json['gamePoints'];
    _firstName = json['first_name'];
    _isOnline = json['is_online'];
    _lastName = json['last_name'];
    _profilePicture = json['profile_picture'];
    _age = json['age'];
    _allowPushNotifications = json['allowPushNotifications'];
    _coverPicture = json['coverPicture'];
    _dob = json['dob'];
    _gender = json['gender'];
    _profession = json['profession'];
    _socketId = json['socket_id'];
    _timezone = json['timezone'];
    _lastActive = json['last_active'];
    _biography = json['biography'];
    _isActivate = json['is_activate'];
  }
  num? _id;
  String? _email;
  String? _name;
  String? _createdAt;
  String? _area;
  String? _city;
  bool? _isVerified;
  String? _phoneNumber;
  String? _updatedAt;
  String? _pseudo;
  dynamic _resetToken;
  dynamic _resetTokenExpiresAt;
  String? _deviceToken;
  String? _deviceType;
  String? _latitude;
  String? _longitude;
  dynamic _socialId;
  dynamic _socialType;
  String? _password;
  num? _gamePoints;
  String? _firstName;
  dynamic _isOnline;
  String? _lastName;
  dynamic _profilePicture;
  dynamic _age;
  bool? _allowPushNotifications;
  dynamic _coverPicture;
  dynamic _dob;
  dynamic _gender;
  dynamic _profession;
  dynamic _socketId;
  String? _timezone;
  dynamic _lastActive;
  dynamic _biography;
  bool? _isActivate;
  FollowingSuggestionsModel copyWith({  num? id,
  String? email,
  String? name,
  String? createdAt,
  String? area,
  String? city,
  bool? isVerified,
  String? phoneNumber,
  String? updatedAt,
  String? pseudo,
  dynamic resetToken,
  dynamic resetTokenExpiresAt,
  String? deviceToken,
  String? deviceType,
  String? latitude,
  String? longitude,
  dynamic socialId,
  dynamic socialType,
  String? password,
  num? gamePoints,
  String? firstName,
  dynamic isOnline,
  String? lastName,
  dynamic profilePicture,
  dynamic age,
  bool? allowPushNotifications,
  dynamic coverPicture,
  dynamic dob,
  dynamic gender,
  dynamic profession,
  dynamic socketId,
  String? timezone,
  dynamic lastActive,
  dynamic biography,
  bool? isActivate,
}) => FollowingSuggestionsModel(  id: id ?? _id,
  email: email ?? _email,
  name: name ?? _name,
  createdAt: createdAt ?? _createdAt,
  area: area ?? _area,
  city: city ?? _city,
  isVerified: isVerified ?? _isVerified,
  phoneNumber: phoneNumber ?? _phoneNumber,
  updatedAt: updatedAt ?? _updatedAt,
  pseudo: pseudo ?? _pseudo,
  resetToken: resetToken ?? _resetToken,
  resetTokenExpiresAt: resetTokenExpiresAt ?? _resetTokenExpiresAt,
  deviceToken: deviceToken ?? _deviceToken,
  deviceType: deviceType ?? _deviceType,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
  socialId: socialId ?? _socialId,
  socialType: socialType ?? _socialType,
  password: password ?? _password,
  gamePoints: gamePoints ?? _gamePoints,
  firstName: firstName ?? _firstName,
  isOnline: isOnline ?? _isOnline,
  lastName: lastName ?? _lastName,
  profilePicture: profilePicture ?? _profilePicture,
  age: age ?? _age,
  allowPushNotifications: allowPushNotifications ?? _allowPushNotifications,
  coverPicture: coverPicture ?? _coverPicture,
  dob: dob ?? _dob,
  gender: gender ?? _gender,
  profession: profession ?? _profession,
  socketId: socketId ?? _socketId,
  timezone: timezone ?? _timezone,
  lastActive: lastActive ?? _lastActive,
  biography: biography ?? _biography,
  isActivate: isActivate ?? _isActivate,
);
  num? get id => _id;
  String? get email => _email;
  String? get name => _name;
  String? get createdAt => _createdAt;
  String? get area => _area;
  String? get city => _city;
  bool? get isVerified => _isVerified;
  String? get phoneNumber => _phoneNumber;
  String? get updatedAt => _updatedAt;
  String? get pseudo => _pseudo;
  dynamic get resetToken => _resetToken;
  dynamic get resetTokenExpiresAt => _resetTokenExpiresAt;
  String? get deviceToken => _deviceToken;
  String? get deviceType => _deviceType;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  dynamic get socialId => _socialId;
  dynamic get socialType => _socialType;
  String? get password => _password;
  num? get gamePoints => _gamePoints;
  String? get firstName => _firstName;
  dynamic get isOnline => _isOnline;
  String? get lastName => _lastName;
  dynamic get profilePicture => _profilePicture;
  dynamic get age => _age;
  bool? get allowPushNotifications => _allowPushNotifications;
  dynamic get coverPicture => _coverPicture;
  dynamic get dob => _dob;
  dynamic get gender => _gender;
  dynamic get profession => _profession;
  dynamic get socketId => _socketId;
  String? get timezone => _timezone;
  dynamic get lastActive => _lastActive;
  dynamic get biography => _biography;
  bool? get isActivate => _isActivate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['email'] = _email;
    map['name'] = _name;
    map['createdAt'] = _createdAt;
    map['area'] = _area;
    map['city'] = _city;
    map['is_verified'] = _isVerified;
    map['phone_number'] = _phoneNumber;
    map['updatedAt'] = _updatedAt;
    map['pseudo'] = _pseudo;
    map['reset_token'] = _resetToken;
    map['reset_token_expires_at'] = _resetTokenExpiresAt;
    map['deviceToken'] = _deviceToken;
    map['deviceType'] = _deviceType;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['socialId'] = _socialId;
    map['socialType'] = _socialType;
    map['password'] = _password;
    map['gamePoints'] = _gamePoints;
    map['first_name'] = _firstName;
    map['is_online'] = _isOnline;
    map['last_name'] = _lastName;
    map['profile_picture'] = _profilePicture;
    map['age'] = _age;
    map['allowPushNotifications'] = _allowPushNotifications;
    map['coverPicture'] = _coverPicture;
    map['dob'] = _dob;
    map['gender'] = _gender;
    map['profession'] = _profession;
    map['socket_id'] = _socketId;
    map['timezone'] = _timezone;
    map['last_active'] = _lastActive;
    map['biography'] = _biography;
    map['is_activate'] = _isActivate;
    return map;
  }

}