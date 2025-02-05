class UserAllChatsModel {
  UserAllChatsModel({
      num? status, 
      bool? error, 
      String? message, 
      Data? data, 
      dynamic metadata,}){
    _status = status;
    _error = error;
    _message = message;
    _data = data;
    _metadata = metadata;
}

  UserAllChatsModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _metadata = json['metadata'];
  }
  num? _status;
  bool? _error;
  String? _message;
  Data? _data;
  dynamic _metadata;
UserAllChatsModel copyWith({  num? status,
  bool? error,
  String? message,
  Data? data,
  dynamic metadata,
}) => UserAllChatsModel(  status: status ?? _status,
  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
  metadata: metadata ?? _metadata,
);
  num? get status => _status;
  bool? get error => _error;
  String? get message => _message;
  Data? get data => _data;
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

class Data {
  Data({
      List<IndividualChats>? individualChats, 
      List<dynamic>? groupChats,}){
    _individualChats = individualChats;
    _groupChats = groupChats;
}

  Data.fromJson(dynamic json) {
    if (json['individualChats'] != null) {
      _individualChats = [];
      json['individualChats'].forEach((v) {
        _individualChats?.add(IndividualChats.fromJson(v));
      });
    }
    if (json['groupChats'] != null) {
      _groupChats = [];
      json['groupChats'].forEach((v) {
        _groupChats?.add(v);
      });
    }
  }
  List<IndividualChats>? _individualChats;
  List<dynamic>? _groupChats;
Data copyWith({  List<IndividualChats>? individualChats,
  List<dynamic>? groupChats,
}) => Data(  individualChats: individualChats ?? _individualChats,
  groupChats: groupChats ?? _groupChats,
);
  List<IndividualChats>? get individualChats => _individualChats;
  List<dynamic>? get groupChats => _groupChats;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_individualChats != null) {
      map['individualChats'] = _individualChats?.map((v) => v.toJson()).toList();
    }
    if (_groupChats != null) {
      map['groupChats'] = _groupChats?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class IndividualChats {
  IndividualChats({
      num? id, 
      num? senderId, 
      num? receiverId, 
      num? requestId, 
      num? groupId, 
      num? lastMessageId, 
      num? deletedId, 
      String? createdAt, 
      String? updatedAt, 
      List<dynamic>? deletedBy, 
      Sender? sender, 
      Receiver? receiver, 
      LastMessage? lastMessage,}){
    _id = id;
    _senderId = senderId;
    _receiverId = receiverId;
    _requestId = requestId;
    _groupId = groupId;
    _lastMessageId = lastMessageId;
    _deletedId = deletedId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedBy = deletedBy;
    _sender = sender;
    _receiver = receiver;
    _lastMessage = lastMessage;
}

  IndividualChats.fromJson(dynamic json) {
    _id = json['id'];
    _senderId = json['senderId'];
    _receiverId = json['receiverId'];
    _requestId = json['requestId'];
    _groupId = json['groupId'];
    _lastMessageId = json['lastMessageId'];
    _deletedId = json['deletedId'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    if (json['deletedBy'] != null) {
      _deletedBy = [];
      json['deletedBy'].forEach((v) {
        _deletedBy?.add(v);
      });
    }
    _sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
    _receiver = json['receiver'] != null ? Receiver.fromJson(json['receiver']) : null;
    _lastMessage = json['lastMessage'] != null ? LastMessage.fromJson(json['lastMessage']) : null;
  }
  num? _id;
  num? _senderId;
  num? _receiverId;
  num? _requestId;
  num? _groupId;
  num? _lastMessageId;
  num? _deletedId;
  String? _createdAt;
  String? _updatedAt;
  List<dynamic>? _deletedBy;
  Sender? _sender;
  Receiver? _receiver;
  LastMessage? _lastMessage;
IndividualChats copyWith({  num? id,
  num? senderId,
  num? receiverId,
  num? requestId,
  num? groupId,
  num? lastMessageId,
  num? deletedId,
  String? createdAt,
  String? updatedAt,
  List<dynamic>? deletedBy,
  Sender? sender,
  Receiver? receiver,
  LastMessage? lastMessage,
}) => IndividualChats(  id: id ?? _id,
  senderId: senderId ?? _senderId,
  receiverId: receiverId ?? _receiverId,
  requestId: requestId ?? _requestId,
  groupId: groupId ?? _groupId,
  lastMessageId: lastMessageId ?? _lastMessageId,
  deletedId: deletedId ?? _deletedId,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  deletedBy: deletedBy ?? _deletedBy,
  sender: sender ?? _sender,
  receiver: receiver ?? _receiver,
  lastMessage: lastMessage ?? _lastMessage,
);
  num? get id => _id;
  num? get senderId => _senderId;
  num? get receiverId => _receiverId;
  num? get requestId => _requestId;
  num? get groupId => _groupId;
  num? get lastMessageId => _lastMessageId;
  num? get deletedId => _deletedId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<dynamic>? get deletedBy => _deletedBy;
  Sender? get sender => _sender;
  Receiver? get receiver => _receiver;
  LastMessage? get lastMessage => _lastMessage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['senderId'] = _senderId;
    map['receiverId'] = _receiverId;
    map['requestId'] = _requestId;
    map['groupId'] = _groupId;
    map['lastMessageId'] = _lastMessageId;
    map['deletedId'] = _deletedId;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_deletedBy != null) {
      map['deletedBy'] = _deletedBy?.map((v) => v.toJson()).toList();
    }
    if (_sender != null) {
      map['sender'] = _sender?.toJson();
    }
    if (_receiver != null) {
      map['receiver'] = _receiver?.toJson();
    }
    if (_lastMessage != null) {
      map['lastMessage'] = _lastMessage?.toJson();
    }
    return map;
  }

}

class LastMessage {
  LastMessage({
      String? message, 
      String? createdAt,}){
    _message = message;
    _createdAt = createdAt;
}

  LastMessage.fromJson(dynamic json) {
    _message = json['message'];
    _createdAt = json['createdAt'];
  }
  String? _message;
  String? _createdAt;
LastMessage copyWith({  String? message,
  String? createdAt,
}) => LastMessage(  message: message ?? _message,
  createdAt: createdAt ?? _createdAt,
);
  String? get message => _message;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['createdAt'] = _createdAt;
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