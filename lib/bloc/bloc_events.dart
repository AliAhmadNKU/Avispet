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
  String? selectedCategory;
  Map<String, dynamic>? currPos;
  double? lat;
  double? long;
  int? cr1;
  int? cr2;
  int? cr3;
  int? cr4;
  int? cr5;
  bool smallDogsAllowed;
  bool bigDogsAllowed;
  bool childPresence;
  bool allDogsAllowed;
  bool leashRequired;
  bool greenSpacesNearby;
  List<String> imageList;
  String? thumbnail;

  GetCreatePostEvent(
    this.selectedCategory,
    this.currPos,
    this.lat,
    this.long,
    this.cr1,
    this.cr2,
    this.cr3,
    this.cr4,
    this.cr5,
    this.smallDogsAllowed,
    this.bigDogsAllowed,
    this.childPresence,
    this.allDogsAllowed,
    this.leashRequired,
    this.greenSpacesNearby,
    this.imageList,
    this.thumbnail,
  );
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
