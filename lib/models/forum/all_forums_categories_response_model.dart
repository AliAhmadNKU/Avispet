class AllForumsCategoriesResponseModel {
  AllForumsCategoriesResponseModel({
      num? status, 
      bool? error, 
      String? message, 
      List<ForumCategoriesModel>? data,
      dynamic metadata,}){
    _status = status;
    _error = error;
    _message = message;
    _data = data;
    _metadata = metadata;
}

  AllForumsCategoriesResponseModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(ForumCategoriesModel.fromJson(v));
      });
    }
    _metadata = json['metadata'];
  }
  num? _status;
  bool? _error;
  String? _message;
  List<ForumCategoriesModel>? _data;
  dynamic _metadata;
AllForumsCategoriesResponseModel copyWith({  num? status,
  bool? error,
  String? message,
  List<ForumCategoriesModel>? data,
  dynamic metadata,
}) => AllForumsCategoriesResponseModel(  status: status ?? _status,
  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
  metadata: metadata ?? _metadata,
);
  num? get status => _status;
  bool? get error => _error;
  String? get message => _message;
  List<ForumCategoriesModel>? get data => _data;
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

class ForumCategoriesModel {
  ForumCategoriesModel({
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

  ForumCategoriesModel.fromJson(dynamic json) {
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
  ForumCategoriesModel copyWith({  num? id,
  String? name,
  String? nameFr,
  String? icon,
  String? createdAt,
  String? updatedAt,
  String? status,
}) => ForumCategoriesModel(  id: id ?? _id,
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