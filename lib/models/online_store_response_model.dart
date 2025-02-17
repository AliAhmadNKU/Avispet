class OnlineStoreResponseModel {
  OnlineStoreResponseModel({
      num? status, 
      bool? error, 
      String? message, 
      List<OnlineStoreModel>? data,
      dynamic metadata,}){
    _status = status;
    _error = error;
    _message = message;
    _data = data;
    _metadata = metadata;
}

  OnlineStoreResponseModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(OnlineStoreModel.fromJson(v));
      });
    }
    _metadata = json['metadata'];
  }
  num? _status;
  bool? _error;
  String? _message;
  List<OnlineStoreModel>? _data;
  dynamic _metadata;
OnlineStoreResponseModel copyWith({  num? status,
  bool? error,
  String? message,
  List<OnlineStoreModel>? data,
  dynamic metadata,
}) => OnlineStoreResponseModel(  status: status ?? _status,
  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
  metadata: metadata ?? _metadata,
);
  num? get status => _status;
  bool? get error => _error;
  String? get message => _message;
  List<OnlineStoreModel>? get data => _data;
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

class OnlineStoreModel {
  OnlineStoreModel({
    String? name,
    num? latitude,
    num? longitude,
    String? address,
    String? profile,
    String? source,
    String? placeId,
    num? rating,
    num? userRating,
    num? distance,
  }) {
    _name = name;
    _latitude = latitude;
    _longitude = longitude;
    _address = address;
    _profile = profile;
    _source = source;
    _placeId = placeId;
    _rating = rating;
    _userRating = userRating;
    _distance = distance;
  }

  OnlineStoreModel.fromJson(dynamic json) {
    _name = json['name'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _address = json['address'];
    _profile = json['profile'];
    _source = json['source'];
    _placeId = json['place_id'];
    _rating = json['rating'];
    _userRating = json['user_rating'];
    _distance = json['distance'];
  }

  String? _name;
  num? _latitude;
  num? _longitude;
  String? _address;
  String? _profile;
  String? _source;
  String? _placeId;
  num? _rating;
  num? _userRating;
  num? _distance;

  OnlineStoreModel copyWith({
    String? name,
    num? latitude,
    num? longitude,
    String? address,
    String? profile,
    String? source,
    String? placeId,
    num? rating,
    num? userRating,
    num? distance,
  }) =>
      OnlineStoreModel(
        name: name ?? _name,
        latitude: latitude ?? _latitude,
        longitude: longitude ?? _longitude,
        address: address ?? _address,
        profile: profile ?? _profile,
        source: source ?? _source,
        placeId: placeId ?? _placeId,
        rating: rating ?? _rating,
        userRating: userRating ?? _userRating,
        distance: distance ?? _distance,
      );

  String? get name => _name;
  num? get latitude => _latitude;
  num? get longitude => _longitude;
  String? get address => _address;
  String? get profile => _profile;
  String? get source => _source;
  String? get placeId => _placeId;
  num? get rating => _rating;
  num? get userRating => _userRating;
  num? get distance => _distance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['address'] = _address;
    map['profile'] = _profile;
    map['source'] = _source;
    map['place_id'] = _placeId;
    map['rating'] = _rating;
    map['user_rating'] = _userRating;
    map['distance'] = _distance;
    return map;
  }
}