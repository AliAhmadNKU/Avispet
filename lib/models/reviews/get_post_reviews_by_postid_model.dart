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
    List<Like>? likes,
    List<dynamic>? comments,
    num? totalLikes,
    num? totalComments,
    bool? isLiked,
    User? user,
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
    _likes = likes ?? [];
    _comments = comments;
    _totalLikes = totalLikes;
    _totalComments = totalComments;
    _tLikes = Rx<int>(totalLikes?.toInt() ?? 0);
    _tcomment = Rx<int>(totalComments?.toInt() ?? 0);
    _isLiked = Rx<bool>(isLiked ?? false);
    _user = user;
  }

  Reviews.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _placeId = json['placeId'];
    _postId = json['postId'];
    _overallRating = json['overall_rating'];
    _placeName = json['place_name'];
    _description = json['description'];
    _images = json['images'] != null ? List<String>.from(json['images']) : [];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _likes = json['likes'] != null
        ? List<Like>.from(json['likes'].map((v) => Like.fromJson(v)))
        : [];
    _comments = json['comments'] != null
        ? List<dynamic>.from(json['comments'])
        : [];
    _totalLikes = json['totalLikes'];
    _totalComments = json['totalComments'];
    _tLikes = Rx<int>(_totalLikes?.toInt() ?? 0);
    _tcomment = Rx<int>(_totalComments?.toInt() ?? 0);
    _isLiked = Rx<bool>(false);
    if (json['user'] != null) {
      _user = User.fromJson(json['user']);
    }
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
  List<Like>? _likes;
  List<dynamic>? _comments;
  num? _totalLikes;
  num? _totalComments;
  late Rx<int> _tLikes;
  late Rx<int> _tcomment;
  Rx<bool> _isLiked = false.obs;
  User? _user; // New field for the user

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
  List<Like>? get likes => _likes;
  List<dynamic>? get comments => _comments;
  num? get totalLikes => _totalLikes;
  num? get totalComments => _totalComments;
  Rx<int> get tLikes => _tLikes;
  Rx<int> get tcomment => _tcomment;
  Rx<bool> get isLiked => _isLiked;
  User? get user => _user; // Getter for user

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
    if (_likes != null) {
      map['likes'] = _likes!.map((v) => v.toJson()).toList();
    }
    if (_comments != null) {
      map['comments'] = _comments;
    }
    map['totalLikes'] = _totalLikes;
    map['totalComments'] = _totalComments;
    if (_user != null) {
      map['user'] = _user!.toJson();
    }
    return map;
  }
}

class User {
  User({
    this.id,
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
    this.biography,
    this.lastActive,
    this.isActivate,
    this.gamePoints,
    this.allowPushNotifications,
    this.resetToken,
    this.resetTokenExpiresAt,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? firstName;
  String? lastName;
  dynamic isOnline;
  String? email;
  String? phoneNumber;
  String? pseudo;
  dynamic profilePicture;
  dynamic coverPicture;
  dynamic profession;
  dynamic dob;
  dynamic age;
  dynamic gender;
  String? city;
  String? area;
  String? timezone;
  dynamic socketId;
  String? latitude;
  String? longitude;
  String? deviceToken;
  dynamic socialId;
  dynamic socialType;
  String? deviceType;
  dynamic biography;
  dynamic lastActive;
  bool? isActivate;
  int? gamePoints;
  bool? allowPushNotifications;
  dynamic resetToken;
  dynamic resetTokenExpiresAt;
  bool? isVerified;
  String? createdAt;
  String? updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    isOnline: json['is_online'],
    email: json['email'],
    phoneNumber: json['phone_number'],
    pseudo: json['pseudo'],
    profilePicture: json['profile_picture'],
    coverPicture: json['coverPicture'],
    profession: json['profession'],
    dob: json['dob'],
    age: json['age'],
    gender: json['gender'],
    city: json['city'],
    area: json['area'],
    timezone: json['timezone'],
    socketId: json['socket_id'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    deviceToken: json['deviceToken'],
    socialId: json['socialId'],
    socialType: json['socialType'],
    deviceType: json['deviceType'],
    biography: json['biography'],
    lastActive: json['last_active'],
    isActivate: json['is_activate'],
    gamePoints: json['gamePoints'],
    allowPushNotifications: json['allowPushNotifications'],
    resetToken: json['reset_token'],
    resetTokenExpiresAt: json['reset_token_expires_at'],
    isVerified: json['is_verified'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'first_name': firstName,
    'last_name': lastName,
    'is_online': isOnline,
    'email': email,
    'phone_number': phoneNumber,
    'pseudo': pseudo,
    'profile_picture': profilePicture,
    'coverPicture': coverPicture,
    'profession': profession,
    'dob': dob,
    'age': age,
    'gender': gender,
    'city': city,
    'area': area,
    'timezone': timezone,
    'socket_id': socketId,
    'latitude': latitude,
    'longitude': longitude,
    'deviceToken': deviceToken,
    'socialId': socialId,
    'socialType': socialType,
    'deviceType': deviceType,
    'biography': biography,
    'last_active': lastActive,
    'is_activate': isActivate,
    'gamePoints': gamePoints,
    'allowPushNotifications': allowPushNotifications,
    'reset_token': resetToken,
    'reset_token_expires_at': resetTokenExpiresAt,
    'is_verified': isVerified,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}



//
// class Reviews {
//   Reviews({
//     num? id,
//     num? userId,
//     String? placeId,
//     num? postId,
//     num? overallRating,
//     String? placeName,
//     String? description,
//     List<String>? images,
//     String? createdAt,
//     String? updatedAt,
//     List<Like>? likes,
//     List<dynamic>? comments,
//     num? totalLikes,
//     num? totalComments,
//     bool? isLiked,
//   }) {
//     _id = id;
//     _userId = userId;
//     _placeId = placeId;
//     _postId = postId;
//     _overallRating = overallRating;
//     _placeName = placeName;
//     _description = description;
//     _images = images;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//     _likes = likes ?? [];
//     _comments = comments;
//     _totalLikes = totalLikes;
//     _totalComments = totalComments;
//     _tLikes = Rx<int>(totalLikes?.toInt() ?? 0);
//     _tcomment = Rx<int>(totalComments?.toInt() ?? 0);
//     _isLiked = Rx<bool>(isLiked ?? false);
//   }
//
//   Reviews.fromJson(dynamic json) {
//     _id = json['id'];
//     _userId = json['userId'];
//     _placeId = json['placeId'];
//     _postId = json['postId'];
//     _overallRating = json['overall_rating'];
//     _placeName = json['place_name'];
//     _description = json['description'];
//     _images = json['images'] != null ? List<String>.from(json['images']) : [];
//     _createdAt = json['createdAt'];
//     _updatedAt = json['updatedAt'];
//     _likes = json['likes'] != null
//         ? List<Like>.from(json['likes'].map((v) => Like.fromJson(v)))
//         : [];
//     _comments = json['comments'] != null
//         ? List<dynamic>.from(json['comments'])
//         : [];
//     // Removed postRatings parsing
//     _totalLikes = json['totalLikes'];
//     _totalComments = json['totalComments'];
//     _tLikes = Rx<int>(_totalLikes?.toInt() ?? 0);
//     _tcomment = Rx<int>(_totalComments?.toInt() ?? 0);
//     _isLiked = Rx<bool>(false);
//   }
//
//   num? _id;
//   num? _userId;
//   String? _placeId;
//   num? _postId;
//   num? _overallRating;
//   String? _placeName;
//   String? _description;
//   List<String>? _images;
//   String? _createdAt;
//   String? _updatedAt;
//   List<Like>? _likes;
//   List<dynamic>? _comments;
//   // Removed _postRatings field
//   num? _totalLikes;
//   num? _totalComments;
//   late Rx<int> _tLikes;
//   late Rx<int> _tcomment;
//   Rx<bool> _isLiked = false.obs;
//
//   num? get id => _id;
//   num? get userId => _userId;
//   String? get placeId => _placeId;
//   num? get postId => _postId;
//   num? get overallRating => _overallRating;
//   String? get placeName => _placeName;
//   String? get description => _description;
//   List<String>? get images => _images;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
//   List<Like>? get likes => _likes;
//   List<dynamic>? get comments => _comments;
//   // Removed postRatings getter
//   num? get totalLikes => _totalLikes;
//   num? get totalComments => _totalComments;
//   Rx<int> get tLikes => _tLikes;
//   Rx<int> get tcomment => _tcomment;
//   Rx<bool> get isLiked => _isLiked;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['userId'] = _userId;
//     map['placeId'] = _placeId;
//     map['postId'] = _postId;
//     map['overall_rating'] = _overallRating;
//     map['place_name'] = _placeName;
//     map['description'] = _description;
//     map['images'] = _images;
//     map['createdAt'] = _createdAt;
//     map['updatedAt'] = _updatedAt;
//     if (_likes != null) {
//       map['likes'] = _likes!.map((v) => v.toJson()).toList();
//     }
//     if (_comments != null) {
//       map['comments'] = _comments;
//     }
//     // Removed postRatings serialization
//     map['totalLikes'] = _totalLikes;
//     map['totalComments'] = _totalComments;
//     return map;
//   }
// }


// class Reviews {
//   Reviews({
//     num? id,
//     num? userId,
//     String? placeId,
//     num? postId,
//     num? overallRating,
//     String? placeName,
//     String? description,
//     List<String>? images,
//     String? createdAt,
//     String? updatedAt,
//     Post? post,
//     User? user,
//     List<Like>? likes, // Changed from dynamic to List<Like>
//     List<dynamic>? comments,
//     List<PostRatings>? postRatings,
//     num? totalLikes,
//     num? totalComments,
//     bool? isLiked,
//   }) {
//     _id = id;
//     _userId = userId;
//     _placeId = placeId;
//     _postId = postId;
//     _overallRating = overallRating;
//     _placeName = placeName;
//     _description = description;
//     _images = images;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//     _post = post;
//     _user = user;
//     _likes = likes ?? []; // Ensure it's initialized properly
//     _comments = comments;
//     _postRatings = postRatings;
//     _totalLikes = totalLikes;
//     _totalComments = totalComments;
//     _tLikes = Rx<int>(totalLikes?.toInt() ?? 0);
//     _tcomment = Rx<int>(totalComments?.toInt() ?? 0);
//     _isLiked = Rx<bool>(isLiked ?? false);
//   }
//
//   Reviews.fromJson(dynamic json) {
//     _id = json['id'];
//     _userId = json['userId'];
//     _placeId = json['placeId'];
//     _postId = json['postId'];
//     _overallRating = json['overall_rating'];
//     _placeName = json['place_name'];
//     _description = json['description'];
//     _images = json['images'] != null ? List<String>.from(json['images']) : [];
//     _createdAt = json['createdAt'];
//     _updatedAt = json['updatedAt'];
//     _post = json['post'] != null ? Post.fromJson(json['post']) : null;
//     _user = json['user'] != null ? User.fromJson(json['user']) : null;
//     _likes = json['likes'] != null
//         ? List<Like>.from(json['likes'].map((v) => Like.fromJson(v))) // Parse into List<Like>
//         : [];
//     _comments = json['comments'] != null ? List<dynamic>.from(json['comments']) : [];
//     _postRatings = json['postRatings'] != null
//         ? List<PostRatings>.from(json['postRatings'].map((v) => PostRatings.fromJson(v)))
//         : [];
//     _totalLikes = json['totalLikes'];
//     _totalComments = json['totalComments'];
//     _tLikes = Rx<int>(_totalLikes?.toInt() ?? 0);
//     _tcomment = Rx<int>(_totalComments?.toInt() ?? 0);
//   }
//
//   num? _id;
//   num? _userId;
//   String? _placeId;
//   num? _postId;
//   num? _overallRating;
//   String? _placeName;
//   String? _description;
//   List<String>? _images;
//   String? _createdAt;
//   String? _updatedAt;
//   Post? _post;
//   User? _user;
//   List<Like>? _likes; // Now using List<Like> instead of dynamic
//   List<dynamic>? _comments;
//   List<PostRatings>? _postRatings;
//   num? _totalLikes;
//   num? _totalComments;
//   late Rx<int> _tLikes;
//   late Rx<int> _tcomment;
//   Rx<bool> _isLiked = false.obs; // Added isLiked as Rx<bool>
//
//   num? get id => _id;
//   num? get userId => _userId;
//   String? get placeId => _placeId;
//   num? get postId => _postId;
//   num? get overallRating => _overallRating;
//   String? get placeName => _placeName;
//   String? get description => _description;
//   List<String>? get images => _images;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
//   Post? get post => _post;
//   User? get user => _user;
//   List<Like>? get likes => _likes; // Getter for likes
//   List<dynamic>? get comments => _comments;
//   List<PostRatings>? get postRatings => _postRatings;
//   num? get totalLikes => _totalLikes;
//   num? get totalComments => _totalComments;
//   Rx<int> get tcomment => _tcomment;
//   Rx<int> get tLikes => _tLikes;
//   Rx<bool> get isLiked => _isLiked; // Getter for isLiked
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['userId'] = _userId;
//     map['placeId'] = _placeId;
//     map['postId'] = _postId;
//     map['overall_rating'] = _overallRating;
//     map['place_name'] = _placeName;
//     map['description'] = _description;
//     map['images'] = _images;
//     map['createdAt'] = _createdAt;
//     map['updatedAt'] = _updatedAt;
//     if (_post != null) {
//       map['post'] = _post?.toJson();
//     }
//     if (_user != null) {
//       map['user'] = _user?.toJson();
//     }
//     if (_likes != null) {
//       map['likes'] = _likes?.map((v) => v.toJson()).toList(); // Convert likes back to JSON
//     }
//     if (_comments != null) {
//       map['comments'] = _comments;
//     }
//     if (_postRatings != null) {
//       map['postRatings'] = _postRatings?.map((v) => v.toJson()).toList();
//     }
//     map['totalLikes'] = _totalLikes;
//     map['totalComments'] = _totalComments;
//
//     return map;
//   }
// }

class Like {
  Like({
    num? id,
    num? postReviewId,
    num? userId,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _postReviewId = postReviewId;
    _userId = userId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Like.fromJson(dynamic json) {
    _id = json['id'];
    _postReviewId = json['postReviewId'];
    _userId = json['userId'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  num? _id;
  num? _postReviewId;
  num? _userId;
  String? _createdAt;
  String? _updatedAt;

  num? get id => _id;
  num? get postReviewId => _postReviewId;
  num? get userId => _userId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['postReviewId'] = _postReviewId;
    map['userId'] = _userId;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
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

