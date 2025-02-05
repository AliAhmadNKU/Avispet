class AllUsersDiscussionModel {
  AllUsersDiscussionModel({
      num? status, 
      bool? error, 
      String? message, 
      List<UserDiscussion>? data,
      dynamic metadata,}){
    _status = status;
    _error = error;
    _message = message;
    _data = data;
    _metadata = metadata;
}

  AllUsersDiscussionModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(UserDiscussion.fromJson(v));
      });
    }
    _metadata = json['metadata'];
  }
  num? _status;
  bool? _error;
  String? _message;
  List<UserDiscussion>? _data;
  dynamic _metadata;
AllUsersDiscussionModel copyWith({  num? status,
  bool? error,
  String? message,
  List<UserDiscussion>? data,
  dynamic metadata,
}) => AllUsersDiscussionModel(  status: status ?? _status,
  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
  metadata: metadata ?? _metadata,
);
  num? get status => _status;
  bool? get error => _error;
  String? get message => _message;
  List<UserDiscussion>? get data => _data;
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

class UserDiscussion {
  UserDiscussion({
      num? id, 
      String? name, 
      String? email, 
      String? profilePicture,}){
    _id = id;
    _name = name;
    _email = email;
    _profilePicture = profilePicture;
}

  UserDiscussion.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _profilePicture = json['profile_picture'];
  }
  num? _id;
  String? _name;
  String? _email;
  String? _profilePicture;
  UserDiscussion copyWith({  num? id,
  String? name,
  String? email,
  String? profilePicture,
}) => UserDiscussion(  id: id ?? _id,
  name: name ?? _name,
  email: email ?? _email,
  profilePicture: profilePicture ?? _profilePicture,
);
  num? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get profilePicture => _profilePicture;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['profile_picture'] = _profilePicture;
    return map;
  }

}