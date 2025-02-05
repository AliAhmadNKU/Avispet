class UserGroupModel {
  UserGroupModel({
      num? status, 
      bool? error, 
      String? message, 
      List<GroupChatModel>? data,
      dynamic metadata,}){
    _status = status;
    _error = error;
    _message = message;
    _data = data;
    _metadata = metadata;
}

  UserGroupModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(GroupChatModel.fromJson(v));
      });
    }
    _metadata = json['metadata'];
  }
  num? _status;
  bool? _error;
  String? _message;
  List<GroupChatModel>? _data;
  dynamic _metadata;
UserGroupModel copyWith({  num? status,
  bool? error,
  String? message,
  List<GroupChatModel>? data,
  dynamic metadata,
}) => UserGroupModel(  status: status ?? _status,
  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
  metadata: metadata ?? _metadata,
);
  num? get status => _status;
  bool? get error => _error;
  String? get message => _message;
  List<GroupChatModel>? get data => _data;
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

class GroupChatModel {
  GroupChatModel({
      num? id, 
      num? userId, 
      String? groupName, 
      String? groupIcon, 
      String? createdAt, 
      List<Members>? members,}){
    _id = id;
    _userId = userId;
    _groupName = groupName;
    _groupIcon = groupIcon;
    _createdAt = createdAt;
    _members = members;
}

  GroupChatModel.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _groupName = json['groupName'];
    _groupIcon = json['groupIcon'];
    _createdAt = json['createdAt'];
    if (json['members'] != null) {
      _members = [];
      json['members'].forEach((v) {
        _members?.add(Members.fromJson(v));
      });
    }
  }
  num? _id;
  num? _userId;
  String? _groupName;
  String? _groupIcon;
  String? _createdAt;
  List<Members>? _members;
  GroupChatModel copyWith({  num? id,
  num? userId,
  String? groupName,
  String? groupIcon,
  String? createdAt,
  List<Members>? members,
}) => GroupChatModel(  id: id ?? _id,
  userId: userId ?? _userId,
  groupName: groupName ?? _groupName,
  groupIcon: groupIcon ?? _groupIcon,
  createdAt: createdAt ?? _createdAt,
  members: members ?? _members,
);
  num? get id => _id;
  num? get userId => _userId;
  String? get groupName => _groupName;
  String? get groupIcon => _groupIcon;
  String? get createdAt => _createdAt;
  List<Members>? get members => _members;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userId'] = _userId;
    map['groupName'] = _groupName;
    map['groupIcon'] = _groupIcon;
    map['createdAt'] = _createdAt;
    if (_members != null) {
      map['members'] = _members?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Members {
  Members({
      num? id, 
      num? groupId, 
      num? userId, 
      bool? isAdmin, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _groupId = groupId;
    _userId = userId;
    _isAdmin = isAdmin;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Members.fromJson(dynamic json) {
    _id = json['id'];
    _groupId = json['groupId'];
    _userId = json['userId'];
    _isAdmin = json['isAdmin'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  num? _id;
  num? _groupId;
  num? _userId;
  bool? _isAdmin;
  String? _createdAt;
  String? _updatedAt;
Members copyWith({  num? id,
  num? groupId,
  num? userId,
  bool? isAdmin,
  String? createdAt,
  String? updatedAt,
}) => Members(  id: id ?? _id,
  groupId: groupId ?? _groupId,
  userId: userId ?? _userId,
  isAdmin: isAdmin ?? _isAdmin,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  num? get groupId => _groupId;
  num? get userId => _userId;
  bool? get isAdmin => _isAdmin;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['groupId'] = _groupId;
    map['userId'] = _userId;
    map['isAdmin'] = _isAdmin;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}