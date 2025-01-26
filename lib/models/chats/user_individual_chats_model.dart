class UserIndividualChatsModel {
  UserIndividualChatsModel({
      num? status, 
      bool? error, 
      String? message, 
      List<ChatModel>? data,
      dynamic metadata,}){
    _status = status;
    _error = error;
    _message = message;
    _data = data;
    _metadata = metadata;
}

  UserIndividualChatsModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(ChatModel.fromJson(v));
      });
    }
    _metadata = json['metadata'];
  }
  num? _status;
  bool? _error;
  String? _message;
  List<ChatModel>? _data;
  dynamic _metadata;
UserIndividualChatsModel copyWith({  num? status,
  bool? error,
  String? message,
  List<ChatModel>? data,
  dynamic metadata,
}) => UserIndividualChatsModel(  status: status ?? _status,
  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
  metadata: metadata ?? _metadata,
);
  num? get status => _status;
  bool? get error => _error;
  String? get message => _message;
  List<ChatModel>? get data => _data;
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

class ChatModel {
  ChatModel({
      num? id, 
      num? senderId, 
      dynamic groupId, 
      num? receiverId, 
      String? message, 
      String? messageType, 
      String? createdAt, 
      Sender? sender, 
      Receiver? receiver,}){
    _id = id;
    _senderId = senderId;
    _groupId = groupId;
    _receiverId = receiverId;
    _message = message;
    _messageType = messageType;
    _createdAt = createdAt;
    _sender = sender;
    _receiver = receiver;
}

  ChatModel.fromJson(dynamic json) {
    _id = json['id'];
    _senderId = json['senderId'];
    _groupId = json['groupId'];
    _receiverId = json['receiverId'];
    _message = json['message'];
    _messageType = json['messageType'];
    _createdAt = json['createdAt'] != null ? json['createdAt'] : DateTime.now().toIso8601String();
    _sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
    _receiver = json['receiver'] != null ? Receiver.fromJson(json['receiver']) : null;
  }
  num? _id;
  num? _senderId;
  dynamic _groupId;
  num? _receiverId;
  String? _message;
  String? _messageType;
  String? _createdAt;
  Sender? _sender;
  Receiver? _receiver;
  ChatModel copyWith({  num? id,
  num? senderId,
  dynamic groupId,
  num? receiverId,
  String? message,
  String? messageType,
  String? createdAt,
  Sender? sender,
  Receiver? receiver,
}) => ChatModel(  id: id ?? _id,
  senderId: senderId ?? _senderId,
  groupId: groupId ?? _groupId,
  receiverId: receiverId ?? _receiverId,
  message: message ?? _message,
  messageType: messageType ?? _messageType,
  createdAt: createdAt ?? _createdAt,
  sender: sender ?? _sender,
  receiver: receiver ?? _receiver,
);
  num? get id => _id;
  num? get senderId => _senderId;
  dynamic get groupId => _groupId;
  num? get receiverId => _receiverId;
  String? get message => _message;
  String? get messageType => _messageType;
  String? get createdAt => _createdAt;
  Sender? get sender => _sender;
  Receiver? get receiver => _receiver;

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
    if (_receiver != null) {
      map['receiver'] = _receiver?.toJson();
    }
    return map;
  }

}

class Receiver {
  Receiver({
      num? id, 
      String? name, 
      String? profilePicture,}){
    _id = id;
    _name = name;
    _profilePicture = profilePicture;
}

  Receiver.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _profilePicture = json['profile_picture'];
  }
  num? _id;
  String? _name;
  String? _profilePicture;
Receiver copyWith({  num? id,
  String? name,
  String? profilePicture,
}) => Receiver(  id: id ?? _id,
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