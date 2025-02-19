// To parse this JSON data, do
//
//     final getAllPostModel = getAllPostModelFromJson(jsonString);

import 'dart:convert';

GetAllPostModel getAllPostModelFromJson(String str) =>
    GetAllPostModel.fromJson(json.decode(str));

String getAllPostModelToJson(GetAllPostModel data) =>
    json.encode(data.toJson());

class GetAllPostModel {
  int status;
  bool error;
  String message;
  GetAllPostModelData data;
  GetAllPostModelMetadata metadata;

  GetAllPostModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
    required this.metadata,
  });

  factory GetAllPostModel.fromJson(Map<String, dynamic> json) =>
      GetAllPostModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: GetAllPostModelData.fromJson(json["data"]),
        metadata: GetAllPostModelMetadata.fromJson(json["metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "message": message,
        "data": data.toJson(),
        "metadata": metadata.toJson(),
      };
}

class GetAllPostModelData {
  bool error;
  DataData data;
  DataMetadata metadata;

  GetAllPostModelData({
    required this.error,
    required this.data,
    required this.metadata,
  });

  factory GetAllPostModelData.fromJson(Map<String, dynamic> json) =>
      GetAllPostModelData(
        error: json["error"],
        data: DataData.fromJson(json["data"]),
        metadata: DataMetadata.fromJson(json["metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "data": data.toJson(),
        "metadata": metadata.toJson(),
      };
}

class DataData {
  List<Post> post;
  List<Review> reviews;

  DataData({
    required this.post,
    required this.reviews,
  });

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
        post: List<Post>.from(json["Post"].map((x) => Post.fromJson(x))),
        reviews:
            List<Review>.from(json["Reviews"].map((x) => Review.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Post": List<dynamic>.from(post.map((x) => x.toJson())),
        "Reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
      };
}

class Post {
  num userRecommendedPercentage;
  num locationDistance;
  String locationDistanceUnit;
  num locationRating;
  num userRatingCount;
  int id;
  int userId;
  String placeId;
  String? websiteName;
  String? openingClosingHour;
  String category;
  double overallRating;
  String? email;
  String? phone;
  String? placeName;
  String description;
  List<String> images;
  String? reservationPlatform;
  String? additionalInfo;
  bool smallDogs;
  bool bigDogs;
  bool child;
  bool allDogs;
  bool dogLeash;
  bool greenSpaces;
  bool currentlyOpen;
  bool isFavorite;
  User? user;
  // List<CommentModel>? comments; // ✅ Include list of comments
  // int likeCount;
  // List<dynamic>? likes;
  DateTime createdAt;
  DateTime updatedAt;

  Post({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.websiteName,
    required this.openingClosingHour,
    required this.category,
    required this.overallRating,
    required this.email,
    required this.phone,
    required this.placeName,
    required this.description,
    required this.images,
    required this.reservationPlatform,
    required this.additionalInfo,
    required this.smallDogs,
    required this.bigDogs,
    required this.child,
    required this.allDogs,
    required this.dogLeash,
    required this.greenSpaces,
    required this.currentlyOpen,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
    required this.locationDistance,
    required this.locationDistanceUnit,
    required this.locationRating,
    required this.userRatingCount,
    required this.userRecommendedPercentage,
      this.user,
    // required this.likeCount,
    // this.comments,
    // this.likes,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        userRecommendedPercentage: json["user_recommended_percentage"] ?? 0.0,
        locationDistance: json["location_distance"] ?? 0.0,
        locationDistanceUnit: json["location_distance_unit"] ?? "",
        locationRating: json["location_rating"] ?? 0.0,
        userRatingCount: json["user_rating_count"] ?? 0,
        id: json["id"],
        userId: json["userId"],
        placeId: json["placeId"],
        websiteName: json["website_name"],
        openingClosingHour: json["opening_closing_hour"],
        category: json["category"],
        overallRating: json["overall_rating"]?.toDouble(),
        email: json["email"],
        phone: json["phone"],
        placeName: json["place_name"],
        description: json["description"],
        images: List<String>.from(json["images"].map((x) => x)),
        reservationPlatform: json["reservation_platform"],
        additionalInfo: json["additional_info"],
        smallDogs: json["small_dogs"],
        bigDogs: json["big_dogs"],
        child: json["child"],
        allDogs: json["all_dogs"],
        dogLeash: json["dog_leash"],
        greenSpaces: json["green_spaces"],
        currentlyOpen: json["currently_open"],
        isFavorite: json["isFavorite"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
     //   user: json["user"] != null ? User.fromJson(json["user"]) : null,
        // comments: json["comments"] != null
        //     ? (json["comments"] as List)
        //         .map((comment) => CommentModel.fromJson(comment))
        //         .toList()
        //     : null,
        // //
        // likeCount: json["_count"]?["likes"] ?? 0, // ✅ Extracting likes count
        // likes: json["likes"] ?? [], // ✅ Assign empty list if null
      );

  Map<String, dynamic> toJson() => {
        "user_recommended_percentage": userRecommendedPercentage,
        "location_distance": locationDistance,
        "location_distance_unit": locationDistanceUnit,
        "location_rating": locationRating,
        "user_rating_count": userRatingCount,
        "id": id,
        "userId": userId,
        "placeId": placeId,
        "website_name": websiteName,
        "opening_closing_hour": openingClosingHour,
        "category": category,
        "overall_rating": overallRating,
        "email": email,
        "phone": phone,
        "place_name": placeName,
        "description": description,
        "images": List<dynamic>.from(images.map((x) => x)),
        "reservation_platform": reservationPlatform,
        "additional_info": additionalInfo,
        "small_dogs": smallDogs,
        "big_dogs": bigDogs,
        "child": child,
        "all_dogs": allDogs,
        "dog_leash": dogLeash,
        "green_spaces": greenSpaces,
        "currently_open": currentlyOpen,
        "isFavorite": isFavorite,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        //"user": this.user!.toJson(),

        // "comments": comments != null
        //     ? comments!.map((comment) => comment.toJson()).toList()
        //     : null, // ✅ Convert list of comments to JSON
        // "_count": {"likes": likeCount},
        // "likes": likes ?? [], // ✅ Convert likes back to empty list if null
      };
}


class User {
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
  String? biography;
  dynamic lastActive;
  bool? isActivate;
  int? gamePoints;
  bool? allowPushNotifications;
  dynamic resetToken;
  dynamic resetTokenExpiresAt;
  bool? isVerified;
  String? createdAt;
  String? updatedAt;

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

  User.fromJson(Map<String, dynamic> json) {
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
    biography = json['biography'];
    lastActive = json['last_active'];
    isActivate = json['is_activate'];
    gamePoints = json['gamePoints'];
    allowPushNotifications = json['allowPushNotifications'];
    resetToken = json['reset_token'];
    resetTokenExpiresAt = json['reset_token_expires_at'];
    isVerified = json['is_verified'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['is_online'] = isOnline;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['pseudo'] = pseudo;
    data['profile_picture'] = profilePicture;
    data['coverPicture'] = coverPicture;
    data['profession'] = profession;
    data['dob'] = dob;
    data['age'] = age;
    data['gender'] = gender;
    data['city'] = city;
    data['area'] = area;
    data['timezone'] = timezone;
    data['socket_id'] = socketId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['deviceToken'] = deviceToken;
    data['socialId'] = socialId;
    data['socialType'] = socialType;
    data['deviceType'] = deviceType;
    data['biography'] = biography;
    data['last_active'] = lastActive;
    data['is_activate'] = isActivate;
    data['gamePoints'] = gamePoints;
    data['allowPushNotifications'] = allowPushNotifications;
    data['reset_token'] = resetToken;
    data['reset_token_expires_at'] = resetTokenExpiresAt;
    data['is_verified'] = isVerified;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}




class Review {
  int id;
  int userId;
  String placeId;
  int postId;
  double overallRating;
  String? placeName;
  String description;
  List<String> images;
  DateTime createdAt;
  DateTime updatedAt;

  Review({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.postId,
    required this.overallRating,
    required this.placeName,
    required this.description,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        userId: json["userId"],
        placeId: json["placeId"],
        postId: json["postId"],
        overallRating: json["overall_rating"]?.toDouble(),
        placeName: json["place_name"],
        description: json["description"],
        images: List<String>.from(json["images"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "placeId": placeId,
        "postId": postId,
        "overall_rating": overallRating,
        "place_name": placeName,
        "description": description,
        "images": List<dynamic>.from(images.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class DataMetadata {
  int totalPostRecords;
  int totalReviewsRecords;
  int totalPages;

  DataMetadata({
    required this.totalPostRecords,
    required this.totalReviewsRecords,
    required this.totalPages,
  });

  factory DataMetadata.fromJson(Map<String, dynamic> json) => DataMetadata(
        totalPostRecords: json["totalPostRecords"],
        totalReviewsRecords: json["totalReviewsRecords"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "totalPostRecords": totalPostRecords,
        "totalReviewsRecords": totalReviewsRecords,
        "totalPages": totalPages,
      };
}

class GetAllPostModelMetadata {
  GetAllPostModelMetadata();

  factory GetAllPostModelMetadata.fromJson(Map<String, dynamic> json) =>
      GetAllPostModelMetadata();

  Map<String, dynamic> toJson() => {};
}
