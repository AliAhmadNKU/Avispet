class AllForumsResponseModel {
  AllForumsResponseModel({
      num? status, 
      bool? error, 
      String? message, 
      List<ForumModel>? data,
      MetadataForum? metadata,}){
    _status = status;
    _error = error;
    _message = message;
    _data = data;
    _metadata = metadata;
}

  AllForumsResponseModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(ForumModel.fromJson(v));
      });
    }
    _metadata = json['metadata'] != null ? MetadataForum.fromJson(json['metadata']['metadata']) : null;
  }
  num? _status;
  bool? _error;
  String? _message;
  List<ForumModel>? _data;
  MetadataForum? _metadata;
AllForumsResponseModel copyWith({  num? status,
  bool? error,
  String? message,
  List<ForumModel>? data,
  MetadataForum? metadata,
}) => AllForumsResponseModel(  status: status ?? _status,
  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
  metadata: metadata ?? _metadata,
);
  num? get status => _status;
  bool? get error => _error;
  String? get message => _message;
  List<ForumModel>? get data => _data;
  MetadataForum? get metadata => _metadata;

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

class MetadataForum {
  MetadataForum({
      num? totalRecords, 
      num? totalPages,}){
    _totalRecords = totalRecords;
    _totalPages = totalPages;
}

  MetadataForum.fromJson(dynamic json) {
    _totalRecords = json['totalRecords'];
    _totalPages = json['totalPages'];
  }
  num? _totalRecords;
  num? _totalPages;
  MetadataForum copyWith({  num? totalRecords,
  num? totalPages,
}) => MetadataForum(  totalRecords: totalRecords ?? _totalRecords,
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

class ForumModel {
  ForumModel({
      num? id, 
      num? userId, 
      num? type, 
      num? dogBreedId, 
      String? title, 
      String? titleFr, 
      String? description, 
      String? descriptionFr, 
      String? createdAt, 
      String? updatedAt, 
      String? status, 
      num? categoryId, 
      bool? isFavorite,
    ForumCategory? category,
      num? totalTopics, 
      num? totalReplies,}){
    _id = id;
    _userId = userId;
    _type = type;
    _dogBreedId = dogBreedId;
    _title = title;
    _titleFr = titleFr;
    _description = description;
    _descriptionFr = descriptionFr;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _status = status;
    _categoryId = categoryId;
    _isFavorite = isFavorite;
    _category = category;
    _totalTopics = totalTopics;
    _totalReplies = totalReplies;
}

  ForumModel.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _type = json['type'];
    _dogBreedId = json['dogBreedId'];
    _title = json['title'];
    _titleFr = json['titleFr'];
    _description = json['description'];
    _descriptionFr = json['descriptionFr'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _status = json['status'];
    _categoryId = json['categoryId'];
    _isFavorite = json['isFavorite'];
    _category = json['category'] != null ? ForumCategory.fromJson(json['category']) : null;
    _totalTopics = json['totalTopics'];
    _totalReplies = json['totalReplies'];
  }
  num? _id;
  num? _userId;
  num? _type;
  num? _dogBreedId;
  String? _title;
  String? _titleFr;
  String? _description;
  String? _descriptionFr;
  String? _createdAt;
  String? _updatedAt;
  String? _status;
  num? _categoryId;
  bool? _isFavorite;
  ForumCategory? _category;
  num? _totalTopics;
  num? _totalReplies;
  ForumModel copyWith({  num? id,
  num? userId,
  num? type,
  num? dogBreedId,
  String? title,
  String? titleFr,
  String? description,
  String? descriptionFr,
  String? createdAt,
  String? updatedAt,
  String? status,
  num? categoryId,
  bool? isFavorite,
    ForumCategory? category,
  num? totalTopics,
  num? totalReplies,
}) => ForumModel(  id: id ?? _id,
  userId: userId ?? _userId,
  type: type ?? _type,
  dogBreedId: dogBreedId ?? _dogBreedId,
  title: title ?? _title,
  titleFr: titleFr ?? _titleFr,
  description: description ?? _description,
  descriptionFr: descriptionFr ?? _descriptionFr,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  status: status ?? _status,
  categoryId: categoryId ?? _categoryId,
  isFavorite: isFavorite ?? _isFavorite,
  category: category ?? _category,
  totalTopics: totalTopics ?? _totalTopics,
  totalReplies: totalReplies ?? _totalReplies,
);
  num? get id => _id;
  num? get userId => _userId;
  num? get type => _type;
  num? get dogBreedId => _dogBreedId;
  String? get title => _title;
  String? get titleFr => _titleFr;
  String? get description => _description;
  String? get descriptionFr => _descriptionFr;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get status => _status;
  num? get categoryId => _categoryId;
  bool? get isFavorite => _isFavorite;
  ForumCategory? get category => _category;
  num? get totalTopics => _totalTopics;
  num? get totalReplies => _totalReplies;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userId'] = _userId;
    map['type'] = _type;
    map['dogBreedId'] = _dogBreedId;
    map['title'] = _title;
    map['titleFr'] = _titleFr;
    map['description'] = _description;
    map['descriptionFr'] = _descriptionFr;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['status'] = _status;
    map['categoryId'] = _categoryId;
    map['isFavorite'] = _isFavorite;
    if (_category != null) {
      map['category'] = _category?.toJson();
    }
    map['totalTopics'] = _totalTopics;
    map['totalReplies'] = _totalReplies;
    return map;
  }

}

class ForumCategory {
  ForumCategory({
      num? id, 
      String? name, 
      String? nameFr, 
      String? icon, 
      String? createdAt, 
      String? updatedAt, 
      String? status,}){
    _id = id;
    _name = name;
    _nameFr = nameFr;
    _icon = icon;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _status = status;
}

  ForumCategory.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _nameFr = json['nameFr'];
    _icon = json['icon'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _status = json['status'];
  }
  num? _id;
  String? _name;
  String? _nameFr;
  String? _icon;
  String? _createdAt;
  String? _updatedAt;
  String? _status;
  ForumCategory copyWith({  num? id,
  String? name,
  String? nameFr,
  String? icon,
  String? createdAt,
  String? updatedAt,
  String? status,
}) => ForumCategory(  id: id ?? _id,
  name: name ?? _name,
  nameFr: nameFr ?? _nameFr,
  icon: icon ?? _icon,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  status: status ?? _status,
);
  num? get id => _id;
  String? get name => _name;
  String? get nameFr => _nameFr;
  String? get icon => _icon;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['nameFr'] = _nameFr;
    map['icon'] = _icon;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['status'] = _status;
    return map;
  }

}