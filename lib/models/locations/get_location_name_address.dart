class GetLocatioByName {
  int? status;
  bool? error;
  String? message;
  List<LocationData>? data;
  Metadata? metadata;

  GetLocatioByName(
      {this.status, this.error, this.message, this.data, this.metadata});

  GetLocatioByName.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LocationData>[];
      json['data'].forEach((v) {
        data!.add(new LocationData.fromJson(v));
      });
    }
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}

class LocationData {
  int? id;
  String? name;
  String? address;
<<<<<<< HEAD
  num? longitude;
  num? latitude;
  num? rating;
  num? userRating;
  num? distance;
=======
  double? longitude;
  double? latitude;
  double? rating;
  num? userRating;
>>>>>>> 12f1d64d5d39f144522a2fa26a7fd7de4635653b
  String? profile;
  String? createdAt;
  String? placeId;
  String? source;
  bool? isFavorite;

  LocationData(
      {this.id,
      this.name,
      this.address,
      this.longitude,
      this.latitude,
      this.rating,
      this.userRating,
<<<<<<< HEAD
      this.distance,
=======
>>>>>>> 12f1d64d5d39f144522a2fa26a7fd7de4635653b
      this.profile,
      this.createdAt,
      this.placeId,
      this.source,
      this.isFavorite});

  LocationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    rating = json['rating'];
<<<<<<< HEAD
    distance = json['distance'];

=======
>>>>>>> 12f1d64d5d39f144522a2fa26a7fd7de4635653b
    userRating = json['user_rating'];
    profile = json['profile'];
    createdAt = json['createdAt'];
    placeId = json['place_id'];
    source = json['source'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
<<<<<<< HEAD
    data['distance'] = this.distance;
=======
>>>>>>> 12f1d64d5d39f144522a2fa26a7fd7de4635653b
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['rating'] = this.rating;
    data['user_rating'] = this.userRating;
    data['profile'] = this.profile;
    data['createdAt'] = this.createdAt;
    data['place_id'] = this.placeId;
    data['source'] = this.source;
    data['isFavorite'] = this.isFavorite;
    return data;
  }
}

class Metadata {
  Metadata();

  Metadata.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
