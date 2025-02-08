class ForumTopicsResponseModel {
  ForumTopicsResponseModel({
      num? status, 
      bool? error, 
      String? message, 
      List<ForumTopicsModel>? data,
      Metadata? metadata,}){
    _status = status;
    _error = error;
    _message = message;
    _data = data;
    _metadata = metadata;
}

  ForumTopicsResponseModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(ForumTopicsModel.fromJson(v));
      });
    }
    _metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
  }
  num? _status;
  bool? _error;
  String? _message;
  List<ForumTopicsModel>? _data;
  Metadata? _metadata;
ForumTopicsResponseModel copyWith({  num? status,
  bool? error,
  String? message,
  List<ForumTopicsModel>? data,
  Metadata? metadata,
}) => ForumTopicsResponseModel(  status: status ?? _status,
  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
  metadata: metadata ?? _metadata,
);
  num? get status => _status;
  bool? get error => _error;
  String? get message => _message;
  List<ForumTopicsModel>? get data => _data;
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

class ForumTopicsModel {
  ForumTopicsModel({
      num? id, 
      num? userId, 
      num? forumCategoryId, 
      String? referenceId, 
      String? title, 
      String? description, 
      num? sendEmail, 
      String? createdAt, 
      String? updatedAt, 
      String? status, 
      num? forumId, 
      num? repliesCount, 
      num? likesCount,}){
    _id = id;
    _userId = userId;
    _forumCategoryId = forumCategoryId;
    _referenceId = referenceId;
    _title = title;
    _description = description;
    _sendEmail = sendEmail;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _status = status;
    _forumId = forumId;
    _repliesCount = repliesCount;
    _likesCount = likesCount;
}

  ForumTopicsModel.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _forumCategoryId = json['forumCategoryId'];
    _referenceId = json['referenceId'];
    _title = json['title'];
    _description = json['description'];
    _sendEmail = json['sendEmail'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _status = json['status'];
    _forumId = json['forumId'];
    _repliesCount = json['repliesCount'];
    _likesCount = json['likesCount'];
  }
  num? _id;
  num? _userId;
  num? _forumCategoryId;
  String? _referenceId;
  String? _title;
  String? _description;
  num? _sendEmail;
  String? _createdAt;
  String? _updatedAt;
  String? _status;
  num? _forumId;
  num? _repliesCount;
  num? _likesCount;
  ForumTopicsModel copyWith({  num? id,
  num? userId,
  num? forumCategoryId,
  String? referenceId,
  String? title,
  String? description,
  num? sendEmail,
  String? createdAt,
  String? updatedAt,
  String? status,
  num? forumId,
  num? repliesCount,
  num? likesCount,
}) => ForumTopicsModel(  id: id ?? _id,
  userId: userId ?? _userId,
  forumCategoryId: forumCategoryId ?? _forumCategoryId,
  referenceId: referenceId ?? _referenceId,
  title: title ?? _title,
  description: description ?? _description,
  sendEmail: sendEmail ?? _sendEmail,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  status: status ?? _status,
  forumId: forumId ?? _forumId,
  repliesCount: repliesCount ?? _repliesCount,
  likesCount: likesCount ?? _likesCount,
);
  num? get id => _id;
  num? get userId => _userId;
  num? get forumCategoryId => _forumCategoryId;
  String? get referenceId => _referenceId;
  String? get title => _title;
  String? get description => _description;
  num? get sendEmail => _sendEmail;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get status => _status;
  num? get forumId => _forumId;
  num? get repliesCount => _repliesCount;
  num? get likesCount => _likesCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userId'] = _userId;
    map['forumCategoryId'] = _forumCategoryId;
    map['referenceId'] = _referenceId;
    map['title'] = _title;
    map['description'] = _description;
    map['sendEmail'] = _sendEmail;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['status'] = _status;
    map['forumId'] = _forumId;
    map['repliesCount'] = _repliesCount;
    map['likesCount'] = _likesCount;
    return map;
  }

}