class GroupChatMessagesModel {
  GroupChatMessagesModel({
      num? status, 
      bool? error, 
      String? message, 
      List<GroupMessageModel>? data,
      dynamic metadata,}){
    _status = status;
    _error = error;
    _message = message;
    _data = data;
    _metadata = metadata;
}

  GroupChatMessagesModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(GroupMessageModel.fromJson(v));
      });
    }
    _metadata = json['metadata'];
  }
  num? _status;
  bool? _error;
  String? _message;
  List<GroupMessageModel>? _data;
  dynamic _metadata;
GroupChatMessagesModel copyWith({  num? status,
  bool? error,
  String? message,
  List<GroupMessageModel>? data,
  dynamic metadata,
}) => GroupChatMessagesModel(  status: status ?? _status,
  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
  metadata: metadata ?? _metadata,
);
  num? get status => _status;
  bool? get error => _error;
  String? get message => _message;
  List<GroupMessageModel>? get data => _data;
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

class GroupMessageModel {
  GroupMessageModel({
      num? id, 
      num? senderId, 
      num? groupId, 
      dynamic receiverId, 
      String? message, 
      String? messageType, 
      String? createdAt, 
      Sender? sender,}){
    _id = id;
    _senderId = senderId;
    _groupId = groupId;
    _receiverId = receiverId;
    _message = message;
    _messageType = messageType;
    _createdAt = createdAt;
    _sender = sender;
}

  GroupMessageModel.fromJson(dynamic json) {
    _id = json['id'];
    _senderId = json['senderId'];
    _groupId = json['groupId'];
    _receiverId = json['receiverId'];
    _message = json['message'];
    _messageType = json['messageType'];
    _createdAt = json['createdAt'];
    _sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
  }
  num? _id;
  num? _senderId;
  num? _groupId;
  dynamic _receiverId;
  String? _message;
  String? _messageType;
  String? _createdAt;
  Sender? _sender;
  GroupMessageModel copyWith({  num? id,
  num? senderId,
  num? groupId,
  dynamic receiverId,
  String? message,
  String? messageType,
  String? createdAt,
  Sender? sender,
}) => GroupMessageModel(  id: id ?? _id,
  senderId: senderId ?? _senderId,
  groupId: groupId ?? _groupId,
  receiverId: receiverId ?? _receiverId,
  message: message ?? _message,
  messageType: messageType ?? _messageType,
  createdAt: createdAt ?? _createdAt,
  sender: sender ?? _sender,
);
  num? get id => _id;
  num? get senderId => _senderId;
  num? get groupId => _groupId;
  dynamic get receiverId => _receiverId;
  String? get message => _message;
  String? get messageType => _messageType;
  String? get createdAt => _createdAt;
  Sender? get sender => _sender;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['senderId'] = _senderId;
    map['groupId'] = _groupId;
    map['receiverId'] = _receiverId;
    map['message'] = _message;
    map['messageType'] = _messageType;
    map['createdAt'] = _createdAt;
    if (_sender != null) {
      map['sender'] = _sender?.toJson();
    }
    return map;
  }

}

class Sender {
  Sender({
      num? id, 
      String? name, 
      String? profilePicture,}){
    _id = id;
    _name = name;
    _profilePicture = profilePicture;
}

  Sender.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _profilePicture = json['profile_picture'];
  }
  num? _id;
  String? _name;
  String? _profilePicture;
Sender copyWith({  num? id,
  String? name,
  String? profilePicture,
}) => Sender(  id: id ?? _id,
  name: name ?? _name,
  profilePicture: profilePicture ?? _profilePicture,
);
  num? get id => _id;
  String? get name => _name;
  String? get profilePicture => _profilePicture;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['profile_picture'] = _profilePicture;
    return map;
  }

}