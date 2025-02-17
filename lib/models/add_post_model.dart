import 'dart:convert';

class AddPost {
  final int status;
  final bool error;
  final String message;
  final PostData data;

  AddPost({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory AddPost.fromJson(Map<String, dynamic> json) {
    return AddPost(
      status: json['status'] ?? 0,
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      data: PostData.fromJson(json['data'] ?? {}),
    );
  }
}

class PostData {
  num userRecommendedPercentage;
  num locationDistance;
  String locationDistanceUnit;
  num locationRating;
  num userRatingCount;
  final int id;
  final int userId;
  final String? placeId;
  final String? websiteName;
  final String? openingClosingHour;
  final String category;
  final double overallRating;
  final String email;
  final String phone;
  final String placeName;
  final String description;
  final double? latitude;
  final double? longitude;
  final List<String> images;
  final String? reservationPlatform;
  final String? additionalInfo;
  final bool smallDogs;
  final bool bigDogs;
  final bool child;
  final bool allDogs;
  final bool dogLeash;
  final bool greenSpaces;
  final bool currentlyOpen;
  final bool isFavorite;
  final String createdAt;
  final String updatedAt;
  final List<PostRating> postRatings;
  final User user;

  PostData({
    required this.locationDistance,
    required this.locationDistanceUnit,
    required this.locationRating,
    required this.userRatingCount,
    required this.userRecommendedPercentage,
    required this.id,
    required this.userId,
    this.placeId,
    this.websiteName,
    this.openingClosingHour,
    required this.category,
    required this.overallRating,
    required this.email,
    required this.phone,
    required this.placeName,
    required this.description,
    this.latitude,
    this.longitude,
    required this.images,
    this.reservationPlatform,
    this.additionalInfo,
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
    required this.postRatings,
    required this.user,
  });

  factory PostData.fromJson(Map<String, dynamic> json) {
    return PostData(

      userRecommendedPercentage: json["user_recommended_percentage"]??0.0,
      locationDistance: json["location_distance"]??0.0,
      locationDistanceUnit: json["location_distance_unit"]??"",
      locationRating: json["location_rating"]??0.0,
      userRatingCount: json["user_rating_count"]??0,
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      placeId: json['placeId'],
      websiteName: json['website_name'],
      openingClosingHour: json['opening_closing_hour'],
      category: json['category'] ?? 'Unknown',
      overallRating: (json['overall_rating'] ?? 0).toDouble(),
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      placeName: json['place_name'] ?? 'No Name',
      description: json['description'] ?? '',
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      reservationPlatform: json['reservation_platform'],
      additionalInfo: json['additional_info'],
      smallDogs: json['small_dogs'] ?? false,
      bigDogs: json['big_dogs'] ?? false,
      child: json['child'] ?? false,
      allDogs: json['all_dogs'] ?? false,
      dogLeash: json['dog_leash'] ?? false,
      greenSpaces: json['green_spaces'] ?? false,
      currentlyOpen: json['currently_open'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      postRatings: (json['postRatings'] as List?)?.map((e) => PostRating.fromJson(e)).toList() ?? [],
      user: User.fromJson(json['user'] ?? {}),
    );
  }
}

class PostRating {
  final int id;
  final int postId;
  final int reviewId;
  final String category;
  final int rating;
  final String createdAt;
  final String updatedAt;

  PostRating({
    required this.id,
    required this.postId,
    required this.reviewId,
    required this.category,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PostRating.fromJson(Map<String, dynamic> json) {
    return PostRating(
      id: json['id'] ?? 0,
      postId: json['postId'] ?? 0,
      reviewId: json['reviewId'] ?? 0,
      category: json['category'] ?? 'Unknown',
      rating: json['rating'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class User {
  final int id;
  final String name;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String pseudo;
  final String? profilePicture;
  final String? coverPicture;
  final String profession;
  final String dob;
  final String age;
  final String gender;
  final String city;
  final String area;
  final String timezone;
  final String latitude;
  final String longitude;
  final String? deviceToken;
  final String deviceType;
  final bool isActivate;
  final bool isVerified;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.pseudo,
    this.profilePicture,
    this.coverPicture,
    required this.profession,
    required this.dob,
    required this.age,
    required this.gender,
    required this.city,
    required this.area,
    required this.timezone,
    required this.latitude,
    required this.longitude,
    this.deviceToken,
    required this.deviceType,
    required this.isActivate,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      pseudo: json['pseudo'] ?? '',
      profilePicture: json['profile_picture'],
      coverPicture: json['coverPicture'],
      profession: json['profession'] ?? '',
      dob: json['dob'] ?? '',
      age: json['age'] ?? '',
      gender: json['gender'] ?? '',
      city: json['city'] ?? '',
      area: json['area'] ?? '',
      timezone: json['timezone'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      deviceToken: json['deviceToken'],
      deviceType: json['deviceType'] ?? 'UNKNOWN',
      isActivate: json['is_activate'] ?? false,
      isVerified: json['is_verified'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
