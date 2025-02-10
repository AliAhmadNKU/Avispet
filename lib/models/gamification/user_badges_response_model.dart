import 'package:avispets/models/gamification/badges_model.dart';

class UserBadgesResponseModel {
  UserBadgesResponseModel({
      num? status, 
      bool? error, 
      String? message, 
      List<BadgesModel>? data,
      dynamic metadata,}){
    _status = status;
    _error = error;
    _message = message;
    _data = data;
    _metadata = metadata;
}

  UserBadgesResponseModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(BadgesModel.fromJson(v));
      });
    }
    _metadata = json['metadata'];
  }
  num? _status;
  bool? _error;
  String? _message;
  List<BadgesModel>? _data;
  dynamic _metadata;
UserBadgesResponseModel copyWith({  num? status,
  bool? error,
  String? message,
  List<BadgesModel>? data,
  dynamic metadata,
}) => UserBadgesResponseModel(  status: status ?? _status,
  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
  metadata: metadata ?? _metadata,
);
  num? get status => _status;
  bool? get error => _error;
  String? get message => _message;
  List<BadgesModel>? get data => _data;
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