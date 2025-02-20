// To parse this JSON data, do
//
//     final getAllPostModel = getAllPostModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

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
  final String firstName;
  final String lastName;
  final String? profilePicture;
  DateTime createdAt;
  DateTime updatedAt;

  bool hasLiked;
  Rx<int> tLikes= 0.obs;

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
    required this.firstName,
    required this.lastName,
     required this.tLikes,
    this.profilePicture,
    required this.hasLiked,


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
    firstName: json["first_name"],
    lastName: json["last_name"],
    profilePicture: json["profile_picture"] ?? null,
    tLikes: (json["like_count"] as int? ?? 0).obs,
    hasLiked: json["has_liked"]??false,


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
    "first_name": firstName,
    "last_name": lastName,
    "profile_picture": profilePicture,
    "like_count": tLikes.value, // Access the underlying int value of tLikes
    "has_liked" : hasLiked
  };

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
