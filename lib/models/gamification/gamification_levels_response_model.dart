class GamificationLevelsResponseModel {
  GamificationLevelsResponseModel({
      num? status, 
      bool? error, 
      String? message, 
      List<GamificationLevelModel>? data,
      Metadata? metadata,}){
    _status = status;
    _error = error;
    _message = message;
    _data = data;
    _metadata = metadata;
}

  GamificationLevelsResponseModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(GamificationLevelModel.fromJson(v));
      });
    }
    _metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
  }
  num? _status;
  bool? _error;
  String? _message;
  List<GamificationLevelModel>? _data;
  Metadata? _metadata;
GamificationLevelsResponseModel copyWith({  num? status,
  bool? error,
  String? message,
  List<GamificationLevelModel>? data,
  Metadata? metadata,
}) => GamificationLevelsResponseModel(  status: status ?? _status,
  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
  metadata: metadata ?? _metadata,
);
  num? get status => _status;
  bool? get error => _error;
  String? get message => _message;
  List<GamificationLevelModel>? get data => _data;
  Metadata? get metadata => _metadata;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_metadata != null) {
      map['metadata'] = _metadata?.toJson();
    }
    return map;
  }

}

class Metadata {
  Metadata({
      num? totalRecords, 
      num? totalPages,}){
    _totalRecords = totalRecords;
    _totalPages = totalPages;
}

  Metadata.fromJson(dynamic json) {
    _totalRecords = json['totalRecords'];
    _totalPages = json['totalPages'];
  }
  num? _totalRecords;
  num? _totalPages;
Metadata copyWith({  num? totalRecords,
  num? totalPages,
}) => Metadata(  totalRecords: totalRecords ?? _totalRecords,
  totalPages: totalPages ?? _totalPages,
);
  num? get totalRecords => _totalRecords;
  num? get totalPages => _totalPages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalRecords'] = _totalRecords;
    map['totalPages'] = _totalPages;
    return map;
  }

}

class GamificationLevelModel {
  GamificationLevelModel({
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

  GamificationLevelModel.fromJson(dynamic json) {
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
  GamificationLevelModel copyWith({  num? id,
  String? name,
  String? nameFr,
  String? minPoints,
  String? maxPoints,
  String? status,
  String? createdAt,
  String? updatedAt,
}) => GamificationLevelModel(  id: id ?? _id,
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