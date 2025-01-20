//     final getSinglePostModel = getSinglePostModelFromJson(jsonString);

import 'dart:convert';

GetSinglePostModel getSinglePostModelFromJson(String str) =>
    GetSinglePostModel.fromJson(json.decode(str));

String getSinglePostModelToJson(GetSinglePostModel data) =>
    json.encode(data.toJson());

class GetSinglePostModel {
  bool? success;
  int? code;
  String? message;
  Data? data;
  Metadata? metadata;

  GetSinglePostModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.metadata,
  });

  factory GetSinglePostModel.fromJson(Map<String, dynamic> json) =>
      GetSinglePostModel(
        success: json["success"],
        code: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        metadata: json["_metadata"] == null
            ? null
            : Metadata.fromJson(json["_metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status": code,
        "message": message,
        "data": data?.toJson(),
        "_metadata": metadata?.toJson(),
      };
}

// Data Class
class Data {
  String? createdAt;
  int? id;
  String? updatedAt;
  int? userId;
  List<FeedImage>? feedImages;
  dynamic favoriteFeed;
  User? user;
  int? totalComments;
  int? totalLikes;
  bool? isLiked;
  bool? isFav;
  bool? hasFollowed;
  bool likeEnable;
  bool bookmarkEnable;
  String? selectedCategory;
  Map<String, dynamic>? currPos;
  double? lat;
  double? long;
  int? cr1;
  int? cr2;
  int? cr3;
  int? cr4;
  int? cr5;
  bool? smallDogsAllowed;
  bool? bigDogsAllowed;
  bool? childPresence;
  bool? allDogsAllowed;
  bool? leashRequired;
  bool? greenSpacesNearby;

  Data({
    this.createdAt,
    this.id,
    this.updatedAt,
    this.userId,
    this.feedImages,
    this.favoriteFeed,
    this.user,
    this.totalComments,
    this.totalLikes,
    this.isLiked,
    this.isFav,
    this.hasFollowed,
    this.likeEnable = false,
    this.bookmarkEnable = false,
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
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        createdAt: json["createdAt"],
        id: json["id"],
        updatedAt: json["updatedAt"],
        userId: json["userId"],
        feedImages: json["feed_images"] == null
            ? []
            : List<FeedImage>.from(
                json["feed_images"]!.map((x) => FeedImage.fromJson(x))),
        favoriteFeed: json["favorite_feed"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        totalComments: json["totalComments"],
        totalLikes: json["totalLikes"],
        isLiked: json["isLiked"] == 1,
        isFav: json["isFav"] == 1,
        hasFollowed: json["hasFollowed"] == 1,
        likeEnable: json["likeEnable"] ?? false,
        bookmarkEnable: json["bookmarkEnable"] ?? false,
        selectedCategory: json["selectedCategory"],
        currPos: json["currPos"] ?? {},
        lat: json["lat"]?.toDouble(),
        long: json["long"]?.toDouble(),
        cr1: json["cr1"],
        cr2: json["cr2"],
        cr3: json["cr3"],
        cr4: json["cr4"],
        cr5: json["cr5"],
        smallDogsAllowed: json["smallDogsAllowed"],
        bigDogsAllowed: json["bigDogsAllowed"],
        childPresence: json["childPresence"],
        allDogsAllowed: json["allDogsAllowed"],
        leashRequired: json["leashRequired"],
        greenSpacesNearby: json["greenSpacesNearby"],
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt,
        "id": id,
        "updatedAt": updatedAt,
        "userId": userId,
        "feed_images": feedImages == null
            ? []
            : List<dynamic>.from(feedImages!.map((x) => x.toJson())),
        "favorite_feed": favoriteFeed,
        "user": user?.toJson(),
        "totalComments": totalComments,
        "totalLikes": totalLikes,
        "isLiked": isLiked == true ? 1 : 0,
        "isFav": isFav == true ? 1 : 0,
        "hasFollowed": hasFollowed == true ? 1 : 0,
        "likeEnable": likeEnable,
        "bookmarkEnable": bookmarkEnable,
        "selectedCategory": selectedCategory,
        "currPos": currPos,
        "lat": lat,
        "long": long,
        "cr1": cr1,
        "cr2": cr2,
        "cr3": cr3,
        "cr4": cr4,
        "cr5": cr5,
        "smallDogsAllowed": smallDogsAllowed,
        "bigDogsAllowed": bigDogsAllowed,
        "childPresence": childPresence,
        "allDogsAllowed": allDogsAllowed,
        "leashRequired": leashRequired,
        "greenSpacesNearby": greenSpacesNearby,
      };
}

class FeedImage {
  int? id;
  String? image;
  String? createdAt;
  String? updatedAt;
  int? feedId;

  FeedImage({
    this.id,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.feedId,
  });

  factory FeedImage.fromJson(Map<String, dynamic> json) => FeedImage(
        id: json["id"],
        image: json["image"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        feedId: json["feedId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "feedId": feedId,
      };
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? profilePicture;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        profilePicture: json["profile_picture"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "profile_picture": profilePicture,
      };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata();

  Map<String, dynamic> toJson() => {};
}
