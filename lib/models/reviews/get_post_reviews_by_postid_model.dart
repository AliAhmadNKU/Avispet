import 'package:avispets/models/get_all_post_modle.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GetPostReviewsByPostidModel {
  GetPostReviewsByPostidModel({
      num? status,
      bool? error,
      String? message,
      List<Reviews>? data,
      dynamic metadata,}){
    _status = status;
    _error = error;
    _message = message;
    _data = data;
    _metadata = metadata;
}

  GetPostReviewsByPostidModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Reviews.fromJson(v));
      });
    }
    _metadata = json['metadata'];
  }
  num? _status;
  bool? _error;
  String? _message;
  List<Reviews>? _data;
  dynamic _metadata;
GetPostReviewsByPostidModel copyWith({  num? status,
  bool? error,
  String? message,
  List<Reviews>? data,
  dynamic metadata,
}) => GetPostReviewsByPostidModel(  status: status ?? _status,
  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
  metadata: metadata ?? _metadata,
);
  num? get status => _status;
  bool? get error => _error;
  String? get message => _message;
  List<Reviews>? get data => _data;
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



class Reviews {
  Reviews({
    num? id,
    num? userId,
    String? placeId,
    num? postId,
    num? overallRating,
    String? placeName,
    String? description,
    List<String>? images,
    String? createdAt,
    String? updatedAt,
    Post? post,
    User? user,
    List<dynamic>? likes,
    List<dynamic>? comments,
    List<PostRatings>? postRatings,
    num? totalLikes,
    num? totalComments,
  }) {
    _id = id;
    _userId = userId;
    _placeId = placeId;
    _postId = postId;
    _overallRating = overallRating;
    _placeName = placeName;
    _description = description;
    _images = images;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _post = post;
    _user = user;
    _likes = likes;
    _comments = comments;
    _postRatings = postRatings;
    _totalLikes = totalLikes;
    _totalComments = totalComments;
    _tLikes = Rx<int>(totalLikes?.toInt() ?? 0); // Initialize Rx<int> properly
    _tcomment = Rx<int>(totalComments?.toInt() ?? 0); // Initialize Rx<int> properly
  }

  Reviews.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _placeId = json['placeId'];
    _postId = json['postId'];
    _overallRating = json['overall_rating'];
    _placeName = json['place_name'];
    _description = json['description'];
    _images = json['images'] != null ? json['images'].cast<String>() : [];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _post = json['post'] != null ? Post.fromJson(json['post']) : null;
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['likes'] != null) {
      _likes = List<dynamic>.from(json['likes']);
    }
    if (json['comments'] != null) {
      _comments = List<dynamic>.from(json['comments']);
    }
    if (json['postRatings'] != null) {
      _postRatings =
          json['postRatings'].map<PostRatings>((v) => PostRatings.fromJson(v)).toList();
    }
    _totalLikes = json['totalLikes'];
    _totalComments = json['totalComments'];
    _tLikes = Rx<int>(_totalLikes?.toInt() ?? 0);
    _tcomment = Rx<int>(_totalComments?.toInt() ?? 0);
  }

  num? _id;
  num? _userId;
  String? _placeId;
  num? _postId;
  num? _overallRating;
  String? _placeName;
  String? _description;
  List<String>? _images;
  String? _createdAt;
  String? _updatedAt;
  Post? _post;
  User? _user;
  List<dynamic>? _likes;
  List<dynamic>? _comments;
  List<PostRatings>? _postRatings;
  num? _totalLikes;
  num? _totalComments;
  late Rx<int> _tLikes;
  late Rx<int> _tcomment; // Reactive variable

  Reviews copyWith({
    num? id,
    num? userId,
    String? placeId,
    num? postId,
    num? overallRating,
    String? placeName,
    String? description,
    List<String>? images,
    String? createdAt,
    String? updatedAt,
    Post? post,
    User? user,
    List<dynamic>? likes,
    List<dynamic>? comments,
    List<PostRatings>? postRatings,
    num? totalLikes,
    num? totalComments,
  }) =>
      Reviews(
        id: id ?? _id,
        userId: userId ?? _userId,
        placeId: placeId ?? _placeId,
        postId: postId ?? _postId,
        overallRating: overallRating ?? _overallRating,
        placeName: placeName ?? _placeName,
        description: description ?? _description,
        images: images ?? _images,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        post: post ?? _post,
        user: user ?? _user,
        likes: likes ?? _likes,
        comments: comments ?? _comments,
        postRatings: postRatings ?? _postRatings,
        totalLikes: totalLikes ?? _totalLikes,
        totalComments: totalComments ?? _totalComments,
      );

  num? get id => _id;
  num? get userId => _userId;
  String? get placeId => _placeId;
  num? get postId => _postId;
  num? get overallRating => _overallRating;
  String? get placeName => _placeName;
  String? get description => _description;
  List<String>? get images => _images;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  Post? get post => _post;
  User? get user => _user;
  List<dynamic>? get likes => _likes;
  List<dynamic>? get comments => _comments;
  List<PostRatings>? get postRatings => _postRatings;
  num? get totalLikes => _totalLikes;
  num? get totalComments => _totalComments;
  Rx<int> get tcomment => _tcomment; // Getter for reactive variable
  Rx<int> get tLikes => _tLikes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userId'] = _userId;
    map['placeId'] = _placeId;
    map['postId'] = _postId;
    map['overall_rating'] = _overallRating;
    map['place_name'] = _placeName;
    map['description'] = _description;
    map['images'] = _images;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_post != null) {
      map['post'] = _post?.toJson();
    }
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    if (_likes != null) {
      map['likes'] = _likes;
    }
    if (_comments != null) {
      map['comments'] = _comments;
    }
    if (_postRatings != null) {
      map['postRatings'] = _postRatings?.map((v) => v.toJson()).toList();
    }
    map['totalLikes'] = _totalLikes;
    map['totalComments'] = _totalComments;
    return map;
  }
}


class PostRatings {
  PostRatings({
      num? id,
      num? postId,
      num? reviewId,
      String? category,
      num? rating,
      String? createdAt,
      String? updatedAt,}){
    _id = id;
    _postId = postId;
    _reviewId = reviewId;
    _category = category;
    _rating = rating;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  PostRatings.fromJson(dynamic json) {
    _id = json['id'];
    _postId = json['postId'];
    _reviewId = json['reviewId'];
    _category = json['category'];
    _rating = json['rating'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  num? _id;
  num? _postId;
  num? _reviewId;
  String? _category;
  num? _rating;
  String? _createdAt;
  String? _updatedAt;
PostRatings copyWith({  num? id,
  num? postId,
  num? reviewId,
  String? category,
  num? rating,
  String? createdAt,
  String? updatedAt,
}) => PostRatings(  id: id ?? _id,
  postId: postId ?? _postId,
  reviewId: reviewId ?? _reviewId,
  category: category ?? _category,
  rating: rating ?? _rating,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  num? get postId => _postId;
  num? get reviewId => _reviewId;
  String? get category => _category;
  num? get rating => _rating;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['postId'] = _postId;
    map['reviewId'] = _reviewId;
    map['category'] = _category;
    map['rating'] = _rating;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}

class User {
  User({
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
      dynamic resetToken,
      dynamic resetTokenExpiresAt,
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

  User.fromJson(dynamic json) {
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
  dynamic _resetToken;
  dynamic _resetTokenExpiresAt;
  bool? _isVerified;
  bool? _isActivate;
  String? _createdAt;
  String? _updatedAt;
User copyWith({  num? id,
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
  dynamic resetToken,
  dynamic resetTokenExpiresAt,
  bool? isVerified,
  bool? isActivate,
  String? createdAt,
  String? updatedAt,

}) => User(  id: id ?? _id,
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
  dynamic get resetToken => _resetToken;
  dynamic get resetTokenExpiresAt => _resetTokenExpiresAt;
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