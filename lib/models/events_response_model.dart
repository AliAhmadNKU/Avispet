class EventsResponseModel {
  EventsResponseModel({
      num? status, 
      bool? error, 
      String? message, 
      List<EventsModel>? data,
      dynamic metadata,}){
    _status = status;
    _error = error;
    _message = message;
    _data = data;
    _metadata = metadata;
}

  EventsResponseModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(EventsModel.fromJson(v));
      });
    }
    _metadata = json['metadata'];
  }
  num? _status;
  bool? _error;
  String? _message;
  List<EventsModel>? _data;
  dynamic _metadata;
EventsResponseModel copyWith({  num? status,
  bool? error,
  String? message,
  List<EventsModel>? data,
  dynamic metadata,
}) => EventsResponseModel(  status: status ?? _status,
  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
  metadata: metadata ?? _metadata,
);
  num? get status => _status;
  bool? get error => _error;
  String? get message => _message;
  List<EventsModel>? get data => _data;
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

class EventsModel {
  EventsModel({
      String? name, 
      String? date, 
      String? time, 
      String? venue, 
      String? city, 
      String? latitude, 
      String? longitude, 
      String? url,}){
    _name = name;
    _date = date;
    _time = time;
    _venue = venue;
    _city = city;
    _latitude = latitude;
    _longitude = longitude;
    _url = url;
}

  EventsModel.fromJson(dynamic json) {
    _name = json['name'];
    _date = json['date'];
    _time = json['time'];
    _venue = json['venue'];
    _city = json['city'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _url = json['url'];
  }
  String? _name;
  String? _date;
  String? _time;
  String? _venue;
  String? _city;
  String? _latitude;
  String? _longitude;
  String? _url;
  EventsModel copyWith({  String? name,
  String? date,
  String? time,
  String? venue,
  String? city,
  String? latitude,
  String? longitude,
  String? url,
}) => EventsModel(  name: name ?? _name,
  date: date ?? _date,
  time: time ?? _time,
  venue: venue ?? _venue,
  city: city ?? _city,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
  url: url ?? _url,
);
  String? get name => _name;
  String? get date => _date;
  String? get time => _time;
  String? get venue => _venue;
  String? get city => _city;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get url => _url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['date'] = _date;
    map['time'] = _time;
    map['venue'] = _venue;
    map['city'] = _city;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['url'] = _url;
    return map;
  }

}