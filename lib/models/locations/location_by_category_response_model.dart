class LocationByCategoryResponseModel {
  LocationByCategoryResponseModel({
      num? status, 
      bool? error, 
      String? message, 
      List<LocationModel>? data,
      dynamic metadata,}){
    _status = status;
    _error = error;
    _message = message;
    _data = data;
    _metadata = metadata;
}

  LocationByCategoryResponseModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(LocationModel.fromJson(v));
      });
    }
    _metadata = json['metadata'];
  }
  num? _status;
  bool? _error;
  String? _message;
  List<LocationModel>? _data;
  dynamic _metadata;
LocationByCategoryResponseModel copyWith({  num? status,
  bool? error,
  String? message,
  List<LocationModel>? data,
  dynamic metadata,
}) => LocationByCategoryResponseModel(  status: status ?? _status,
  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
  metadata: metadata ?? _metadata,
);
  num? get status => _status;
  bool? get error => _error;
  String? get message => _message;
  List<LocationModel>? get data => _data;
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

class LocationModel {
  LocationModel({
      String? name, 
      num? latitude, 
      num? longitude, 
      String? address, 
      num? rating, 
      num? userRating, 
      String? profile, 
      String? source, 
      String? placeId,}){
    _name = name;
    _latitude = latitude;
    _longitude = longitude;
    _address = address;
    _rating = rating;
    _userRating = userRating;
    _profile = profile;
    _source = source;
    _placeId = placeId;
}

  LocationModel.fromJson(dynamic json) {
    _name = json['name'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _address = json['address'];
    _rating = json['rating'];
    _userRating = json['user_rating'];
    _profile = json['profile'];
    _source = json['source'];
    _placeId = json['place_id'];
  }
  String? _name;
  num? _latitude;
  num? _longitude;
  String? _address;
  num? _rating;
  num? _userRating;
  String? _profile;
  String? _source;
  String? _placeId;
  LocationModel copyWith({  String? name,
  num? latitude,
  num? longitude,
  String? address,
  num? rating,
  num? userRating,
  String? profile,
  String? source,
  String? placeId,
}) => LocationModel(  name: name ?? _name,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
  address: address ?? _address,
  rating: rating ?? _rating,
  userRating: userRating ?? _userRating,
  profile: profile ?? _profile,
  source: source ?? _source,
  placeId: placeId ?? _placeId,
);
  String? get name => _name;
  num? get latitude => _latitude;
  num? get longitude => _longitude;
  String? get address => _address;
  num? get rating => _rating;
  num? get userRating => _userRating;
  String? get profile => _profile;
  String? get source => _source;
  String? get placeId => _placeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['address'] = _address;
    map['rating'] = _rating;
    map['user_rating'] = _userRating;
    map['profile'] = _profile;
    map['source'] = _source;
    map['place_id'] = _placeId;
    return map;
  }

}