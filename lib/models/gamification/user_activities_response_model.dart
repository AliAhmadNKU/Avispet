import 'package:avispets/models/gamification/badges_model.dart';

class UserActivitiesResponseModel {
  UserActivitiesResponseModel({
      num? status, 
      bool? error, 
      String? message,
    UserActivitiesModel? data,
      dynamic metadata,}){
    _status = status;
    _error = error;
    _message = message;
    _data = data;
    _metadata = metadata;
}

  UserActivitiesResponseModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? UserActivitiesModel.fromJson(json['data']) : null;
    _metadata = json['metadata'];
  }
  num? _status;
  bool? _error;
  String? _message;
  UserActivitiesModel? _data;
  dynamic _metadata;
UserActivitiesResponseModel copyWith({  num? status,
  bool? error,
  String? message,
  UserActivitiesModel? data,
  dynamic metadata,
}) => UserActivitiesResponseModel(  status: status ?? _status,
  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
  metadata: metadata ?? _metadata,
);
  num? get status => _status;
  bool? get error => _error;
  String? get message => _message;
  UserActivitiesModel? get data => _data;
  dynamic get metadata => _metadata;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['metadata'] = _metadata;
    return map;
  }

}

class UserActivitiesModel {
  UserActivitiesModel({
      UserProfile? userProfile, 
      List<BadgesModel>? badges,
      List<Levels>? levels, 
      ActivityCounts? activityCounts,}){
    _userProfile = userProfile;
    _badges = badges;
    _levels = levels;
    _activityCounts = activityCounts;
}

  UserActivitiesModel.fromJson(dynamic json) {
    _userProfile = json['userProfile'] != null ? UserProfile.fromJson(json['userProfile']) : null;
    if (json['badges'] != null) {
      _badges = [];
      json['badges'].forEach((v) {
        _badges?.add(BadgesModel.fromJson(v));
      });
    }
    if (json['levels'] != null) {
      _levels = [];
      json['levels'].forEach((v) {
        _levels?.add(Levels.fromJson(v));
      });
    }
    _activityCounts = json['activityCounts'] != null ? ActivityCounts.fromJson(json['activityCounts']) : null;
  }
  UserProfile? _userProfile;
  List<BadgesModel>? _badges;
  List<Levels>? _levels;
  ActivityCounts? _activityCounts;
  UserActivitiesModel copyWith({  UserProfile? userProfile,
  List<BadgesModel>? badges,
  List<Levels>? levels,
  ActivityCounts? activityCounts,
}) => UserActivitiesModel(  userProfile: userProfile ?? _userProfile,
  badges: badges ?? _badges,
  levels: levels ?? _levels,
  activityCounts: activityCounts ?? _activityCounts,
);
  UserProfile? get userProfile => _userProfile;
  List<BadgesModel>? get badges => _badges;
  List<Levels>? get levels => _levels;
  ActivityCounts? get activityCounts => _activityCounts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_userProfile != null) {
      map['userProfile'] = _userProfile?.toJson();
    }
    if (_badges != null) {
      map['badges'] = _badges?.map((v) => v.toJson()).toList();
    }
    if (_levels != null) {
      map['levels'] = _levels?.map((v) => v.toJson()).toList();
    }
    if (_activityCounts != null) {
      map['activityCounts'] = _activityCounts?.toJson();
    }
    return map;
  }

}

class ActivityCounts {
  ActivityCounts({
      num? forumSubmissionCount, 
      num? postCount, 
      num? postReviewCount, 
      num? questionSubmitted, 
      num? answersSubmitted,}){
    _forumSubmissionCount = forumSubmissionCount;
    _postCount = postCount;
    _postReviewCount = postReviewCount;
    _questionSubmitted = questionSubmitted;
    _answersSubmitted = answersSubmitted;
}

  ActivityCounts.fromJson(dynamic json) {
    _forumSubmissionCount = json['forumSubmissionCount'];
    _postCount = json['postCount'];
    _postReviewCount = json['postReviewCount'];
    _questionSubmitted = json['questionSubmitted'];
    _answersSubmitted = json['answersSubmitted'];
  }
  num? _forumSubmissionCount;
  num? _postCount;
  num? _postReviewCount;
  num? _questionSubmitted;
  num? _answersSubmitted;
ActivityCounts copyWith({  num? forumSubmissionCount,
  num? postCount,
  num? postReviewCount,
  num? questionSubmitted,
  num? answersSubmitted,
}) => ActivityCounts(  forumSubmissionCount: forumSubmissionCount ?? _forumSubmissionCount,
  postCount: postCount ?? _postCount,
  postReviewCount: postReviewCount ?? _postReviewCount,
  questionSubmitted: questionSubmitted ?? _questionSubmitted,
  answersSubmitted: answersSubmitted ?? _answersSubmitted,
);
  num? get forumSubmissionCount => _forumSubmissionCount;
  num? get postCount => _postCount;
  num? get postReviewCount => _postReviewCount;
  num? get questionSubmitted => _questionSubmitted;
  num? get answersSubmitted => _answersSubmitted;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['forumSubmissionCount'] = _forumSubmissionCount;
    map['postCount'] = _postCount;
    map['postReviewCount'] = _postReviewCount;
    map['questionSubmitted'] = _questionSubmitted;
    map['answersSubmitted'] = _answersSubmitted;
    return map;
  }

}

class Levels {
  Levels({
      num? id, 
      num? userId, 
      num? gamificationLevelId, 
      String? assignedAt, 
      GamificationLevel? gamificationLevel,}){
    _id = id;
    _userId = userId;
    _gamificationLevelId = gamificationLevelId;
    _assignedAt = assignedAt;
    _gamificationLevel = gamificationLevel;
}

  Levels.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _gamificationLevelId = json['gamificationLevelId'];
    _assignedAt = json['assignedAt'];
    _gamificationLevel = json['gamificationLevel'] != null ? GamificationLevel.fromJson(json['gamificationLevel']) : null;
  }
  num? _id;
  num? _userId;
  num? _gamificationLevelId;
  String? _assignedAt;
  GamificationLevel? _gamificationLevel;
Levels copyWith({  num? id,
  num? userId,
  num? gamificationLevelId,
  String? assignedAt,
  GamificationLevel? gamificationLevel,
}) => Levels(  id: id ?? _id,
  userId: userId ?? _userId,
  gamificationLevelId: gamificationLevelId ?? _gamificationLevelId,
  assignedAt: assignedAt ?? _assignedAt,
  gamificationLevel: gamificationLevel ?? _gamificationLevel,
);
  num? get id => _id;
  num? get userId => _userId;
  num? get gamificationLevelId => _gamificationLevelId;
  String? get assignedAt => _assignedAt;
  GamificationLevel? get gamificationLevel => _gamificationLevel;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userId'] = _userId;
    map['gamificationLevelId'] = _gamificationLevelId;
    map['assignedAt'] = _assignedAt;
    if (_gamificationLevel != null) {
      map['gamificationLevel'] = _gamificationLevel?.toJson();
    }
    return map;
  }

}

class GamificationLevel {
  GamificationLevel({
      num? id, 
      String? name, 
      String? nameFr, 
      String? minPoints, 
      String? maxPoints, 
      String? status, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _name = name;
    _nameFr = nameFr;
    _minPoints = minPoints;
    _maxPoints = maxPoints;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  GamificationLevel.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _nameFr = json['nameFr'];
    _minPoints = json['minPoints'];
    _maxPoints = json['maxPoints'];
    _status = json['status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  num? _id;
  String? _name;
  String? _nameFr;
  String? _minPoints;
  String? _maxPoints;
  String? _status;
  String? _createdAt;
  String? _updatedAt;
GamificationLevel copyWith({  num? id,
  String? name,
  String? nameFr,
  String? minPoints,
  String? maxPoints,
  String? status,
  String? createdAt,
  String? updatedAt,
}) => GamificationLevel(  id: id ?? _id,
  name: name ?? _name,
  nameFr: nameFr ?? _nameFr,
  minPoints: minPoints ?? _minPoints,
  maxPoints: maxPoints ?? _maxPoints,
  status: status ?? _status,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  String? get name => _name;
  String? get nameFr => _nameFr;
  String? get minPoints => _minPoints;
  String? get maxPoints => _maxPoints;
  String? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['nameFr'] = _nameFr;
    map['minPoints'] = _minPoints;
    map['maxPoints'] = _maxPoints;
    map['status'] = _status;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}

class UserProfile {
  UserProfile({
      num? id, 
      String? name, 
      String? firstName, 
      String? lastName, 
      String? email, 
      String? phoneNumber, 
      num? gamePoints, 
      List<dynamic>? userGameActivities,}){
    _id = id;
    _name = name;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _phoneNumber = phoneNumber;
    _gamePoints = gamePoints;
    _userGameActivities = userGameActivities;
}

  UserProfile.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _email = json['email'];
    _phoneNumber = json['phone_number'];
    _gamePoints = json['gamePoints'];
    if (json['userGameActivities'] != null) {
      _userGameActivities = [];
      json['userGameActivities'].forEach((v) {
        _userGameActivities?.add(v);
      });
    }
  }
  num? _id;
  String? _name;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phoneNumber;
  num? _gamePoints;
  List<dynamic>? _userGameActivities;
UserProfile copyWith({  num? id,
  String? name,
  String? firstName,
  String? lastName,
  String? email,
  String? phoneNumber,
  num? gamePoints,
  List<dynamic>? userGameActivities,
}) => UserProfile(  id: id ?? _id,
  name: name ?? _name,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  email: email ?? _email,
  phoneNumber: phoneNumber ?? _phoneNumber,
  gamePoints: gamePoints ?? _gamePoints,
  userGameActivities: userGameActivities ?? _userGameActivities,
);
  num? get id => _id;
  String? get name => _name;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  num? get gamePoints => _gamePoints;
  List<dynamic>? get userGameActivities => _userGameActivities;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['email'] = _email;
    map['phone_number'] = _phoneNumber;
    map['gamePoints'] = _gamePoints;
    if (_userGameActivities != null) {
      map['userGameActivities'] = _userGameActivities?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}