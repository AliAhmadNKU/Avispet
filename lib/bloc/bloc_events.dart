import 'dart:io';

abstract class LoginEvent {}

abstract class ForgotEvent {}

abstract class CreateProfileEvent {}

abstract class CreateAnimalEvent {}

abstract class EditAnimalEvent {}

abstract class ChangePassword {}

abstract class ContactUs {}

abstract class EditProfile {}

abstract class LikeBookmarkEvent {}

abstract class FollowUnfollow {}

abstract class CreatePost {}

abstract class CreateForumTopic {}

// --login
class GetLoginEvent extends LoginEvent {
  String? email;
  String? password;
  String currentTimeZone;
  String latitude;
  String longitude;
  String deviceType;

  GetLoginEvent(this.email, this.password, this.currentTimeZone, this.latitude,
      this.longitude, this.deviceType);
}

//  --forgot
class GetForgotEvent extends ForgotEvent {
  String? email;
  GetForgotEvent(this.email);
}

//  --createProfile
class GetCreateProfileEvent extends CreateProfileEvent {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? confirmPassword;
  String? timeZone;
  String? latitude;
  String? longitude;
  String? pseudo;
  String? phoneNumber;
  String? city;
  String? address;
  String? deviceType;
  bool termsCondition;

  GetCreateProfileEvent(
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.confirmPassword,
      this.timeZone,
      this.latitude,
      this.longitude,
      this.pseudo,
      this.phoneNumber,
      this.city,
      this.address,
      this.deviceType,
      this.termsCondition);
}

//  --createAnimal
class GetCreateAnimalEvent extends CreateAnimalEvent {
  String? name;
  String? type;
  String? race;
  int? weight;
  int? age;

  String? gender;
  String? sterilized;
  List<String>? image;

  GetCreateAnimalEvent(this.name, this.type, this.race, this.weight, this.age,
      this.gender, this.sterilized, this.image);
}

//  --createPost
class GetCreatePostEvent extends CreatePost {

 String address;
  num? location_distance;
  num ?location_rating;
 num ?user_rating_count;
  int userId;
  num lat;
  num lng;
  num distance;
  num totalUserRating;
  String placeId;
  String email;
  String phone;
  List<String> images;
  String category;
  double overallRating;
  String placeName;
  String description;
  bool smallDogs;
  bool bigDogs;
  bool child;
  bool allDogs;
  bool dogLeash;
  bool greenSpaces;
  String reservationPlatform;
  String additionalInfo;
  bool isFavourite;
  List<PostRating> postRatings;

  GetCreatePostEvent({
    required this.userId,
    required this.placeId,
    required this.email,
    required this.phone,
    required this.images,
    required this.category,
    required this.overallRating,
    required this.placeName,
    required this.description,
    required this.smallDogs,
    required this.bigDogs,
    required this.child,
    required this.allDogs,
    required this.dogLeash,
    required this.greenSpaces,
    required this.reservationPlatform,
    required this.additionalInfo,
    required this.isFavourite,
    required this.postRatings,
    required this.lat,
    required this.lng,
    required this.distance,
    required this.totalUserRating,
    required this.location_distance,
    required this.location_rating,
    required this.user_rating_count,
    required this.address,

  });
}

class PostRating {
  String category;
  int rating;

  PostRating({
    required this.category,
    required this.rating,
  });

  factory PostRating.fromJson(Map<String, dynamic> json) {
    return PostRating(
      category: json['category'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'rating': rating,
    };
  }
}

class PostRatingX {
  String category;
  int rating;

  PostRatingX({
    required this.category,
    required this.rating,
  });

  factory PostRatingX.fromJson(Map<String, dynamic> json) {
    return PostRatingX(
      category: json['category'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'rating': rating,
    };
  }
}


//  --editAnimal
class GetEditAnimalEvent extends EditAnimalEvent {
  String? id;
  String? name;
  String? specices;
  String? race;
  String? dob;
  String? gender;
  int? weight;
  String? sterilized;
  List<String>? image;

  GetEditAnimalEvent(
    this.id,
    this.name,
    this.specices,
    this.race,
    this.dob,
    this.gender,
    this.weight,
    this.sterilized,
    this.image,
  );
}

//  --changePassword
class GetChangePasswordEvent extends ChangePassword {
  String? currentPassword;
  String? newPassword;
  String? confirmPassword;

  GetChangePasswordEvent(
      this.currentPassword, this.newPassword, this.confirmPassword);
}

class GetNewPasswordEvent extends ChangePassword {
  String? email;
  String? newPassword;
  String? confirmPassword;

  GetNewPasswordEvent(this.email, this.newPassword, this.confirmPassword);
}

//  --contactUs
class GetContactUsEvent extends ContactUs {
  String? name;
  String? email;
  String? message;

  GetContactUsEvent(this.name, this.email, this.message);
}

//  --editProfile
class GetEditProfileEvent extends EditProfile {
  String? firstName;
  String? lastName;
  String? email;
  String? pseudo;
  String? phoneNumber;
  String? city;
  String? address;
  String? bio;
  String? from;
  //String? department;

  GetEditProfileEvent(this.firstName, this.lastName, this.email, this.pseudo,
      this.phoneNumber, this.city, this.address, this.bio, this.from);
}

//  --likeBookmark
class GetLikeBookmarkEvent extends LikeBookmarkEvent {
  int? type;
  String? feedId;
  GetLikeBookmarkEvent(this.type, this.feedId);
}

class GetFollowUnfollowEvent extends FollowUnfollow {
  String? followId;
  GetFollowUnfollowEvent(this.followId);
}

class GetCreateForumTopicEvent extends CreateForumTopic {
  int? forumId;
  String? title;
  String? desc;
  String? forumCategoryCode;
  String? isEmailSend;

  GetCreateForumTopicEvent(this.forumId, this.title, this.desc,
      this.forumCategoryCode, this.isEmailSend);
}
