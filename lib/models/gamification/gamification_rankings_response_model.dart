class GamificationRankingsResponseModel {
  GamificationRankingsResponseModel({
      num? status, 
      bool? error, 
      String? message, 
      List<RankingModel>? data,
      dynamic metadata,}){
    _status = status;
    _error = error;
    _message = message;
    _data = data;
    _metadata = metadata;
}

  GamificationRankingsResponseModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(RankingModel.fromJson(v));
      });
    }
    _metadata = json['metadata'];
  }
  num? _status;
  bool? _error;
  String? _message;
  List<RankingModel>? _data;
  dynamic _metadata;
GamificationRankingsResponseModel copyWith({  num? status,
  bool? error,
  String? message,
  List<RankingModel>? data,
  dynamic metadata,
}) => GamificationRankingsResponseModel(  status: status ?? _status,
  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
  metadata: metadata ?? _metadata,
);
  num? get status => _status;
  bool? get error => _error;
  String? get message => _message;
  List<RankingModel>? get data => _data;
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

class RankingModel {
  RankingModel({
      String? email, 
      String? profilePicture, 
      String? name, 
      num? gamePoints, 
      dynamic coverPicture, 
      num? ranking,}){
    _email = email;
    _profilePicture = profilePicture;
    _name = name;
    _gamePoints = gamePoints;
    _coverPicture = coverPicture;
    _ranking = ranking;
}

  RankingModel.fromJson(dynamic json) {
    _email = json['email'];
    _profilePicture = json['profile_picture'];
    _name = json['name'];
    _gamePoints = json['gamePoints'];
    _coverPicture = json['coverPicture'];
    _ranking = json['ranking'];
  }
  String? _email;
  String? _profilePicture;
  String? _name;
  num? _gamePoints;
  dynamic _coverPicture;
  num? _ranking;
  RankingModel copyWith({  String? email,
  String? profilePicture,
  String? name,
  num? gamePoints,
  dynamic coverPicture,
  num? ranking,
}) => RankingModel(  email: email ?? _email,
  profilePicture: profilePicture ?? _profilePicture,
  name: name ?? _name,
  gamePoints: gamePoints ?? _gamePoints,
  coverPicture: coverPicture ?? _coverPicture,
  ranking: ranking ?? _ranking,
);
  String? get email => _email;
  String? get profilePicture => _profilePicture;
  String? get name => _name;
  num? get gamePoints => _gamePoints;
  dynamic get coverPicture => _coverPicture;
  num? get ranking => _ranking;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['profile_picture'] = _profilePicture;
    map['name'] = _name;
    map['gamePoints'] = _gamePoints;
    map['coverPicture'] = _coverPicture;
    map['ranking'] = _ranking;
    return map;
  }

}