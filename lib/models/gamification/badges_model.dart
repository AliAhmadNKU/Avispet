class BadgesModel {
  BadgesModel({
      num? id, 
      String? type, 
      num? userId, 
      num? gamificationBadgeId, 
      String? createdAt, 
      String? updatedAt, 
      GamificationBadge? gamificationBadge,}){
    _id = id;
    _type = type;
    _userId = userId;
    _gamificationBadgeId = gamificationBadgeId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _gamificationBadge = gamificationBadge;
}

  BadgesModel.fromJson(dynamic json) {
    _id = json['id'];
    _type = json['type'];
    _userId = json['userId'];
    _gamificationBadgeId = json['gamificationBadgeId'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _gamificationBadge = json['gamificationBadge'] != null ? GamificationBadge.fromJson(json['gamificationBadge']) : null;
  }
  num? _id;
  String? _type;
  num? _userId;
  num? _gamificationBadgeId;
  String? _createdAt;
  String? _updatedAt;
  GamificationBadge? _gamificationBadge;
BadgesModel copyWith({  num? id,
  String? type,
  num? userId,
  num? gamificationBadgeId,
  String? createdAt,
  String? updatedAt,
  GamificationBadge? gamificationBadge,
}) => BadgesModel(  id: id ?? _id,
  type: type ?? _type,
  userId: userId ?? _userId,
  gamificationBadgeId: gamificationBadgeId ?? _gamificationBadgeId,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  gamificationBadge: gamificationBadge ?? _gamificationBadge,
);
  num? get id => _id;
  String? get type => _type;
  num? get userId => _userId;
  num? get gamificationBadgeId => _gamificationBadgeId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  GamificationBadge? get gamificationBadge => _gamificationBadge;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['type'] = _type;
    map['userId'] = _userId;
    map['gamificationBadgeId'] = _gamificationBadgeId;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_gamificationBadge != null) {
      map['gamificationBadge'] = _gamificationBadge?.toJson();
    }
    return map;
  }

}

class GamificationBadge {
  GamificationBadge({
      num? id, 
      String? type, 
      String? name, 
      String? nameFr, 
      String? mission, 
      String? missionFr, 
      String? dedicated, 
      String? dedicatedFr, 
      String? categoryId, 
      dynamic subCategoryId, 
      num? number, 
      String? icon, 
      String? status, 
      String? createdAt, 
      String? updatedAt, 
      dynamic categoryJson, 
      dynamic subCategoryJson,}){
    _id = id;
    _type = type;
    _name = name;
    _nameFr = nameFr;
    _mission = mission;
    _missionFr = missionFr;
    _dedicated = dedicated;
    _dedicatedFr = dedicatedFr;
    _categoryId = categoryId;
    _subCategoryId = subCategoryId;
    _number = number;
    _icon = icon;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _categoryJson = categoryJson;
    _subCategoryJson = subCategoryJson;
}

  GamificationBadge.fromJson(dynamic json) {
    _id = json['id'];
    _type = json['type'];
    _name = json['name'];
    _nameFr = json['nameFr'];
    _mission = json['mission'];
    _missionFr = json['missionFr'];
    _dedicated = json['dedicated'];
    _dedicatedFr = json['dedicatedFr'];
    _categoryId = json['categoryId'];
    _subCategoryId = json['subCategoryId'];
    _number = json['number'];
    _icon = json['icon'];
    _status = json['status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _categoryJson = json['categoryJson'];
    _subCategoryJson = json['subCategoryJson'];
  }
  num? _id;
  String? _type;
  String? _name;
  String? _nameFr;
  String? _mission;
  String? _missionFr;
  String? _dedicated;
  String? _dedicatedFr;
  String? _categoryId;
  dynamic _subCategoryId;
  num? _number;
  String? _icon;
  String? _status;
  String? _createdAt;
  String? _updatedAt;
  dynamic _categoryJson;
  dynamic _subCategoryJson;
GamificationBadge copyWith({  num? id,
  String? type,
  String? name,
  String? nameFr,
  String? mission,
  String? missionFr,
  String? dedicated,
  String? dedicatedFr,
  String? categoryId,
  dynamic subCategoryId,
  num? number,
  String? icon,
  String? status,
  String? createdAt,
  String? updatedAt,
  dynamic categoryJson,
  dynamic subCategoryJson,
}) => GamificationBadge(  id: id ?? _id,
  type: type ?? _type,
  name: name ?? _name,
  nameFr: nameFr ?? _nameFr,
  mission: mission ?? _mission,
  missionFr: missionFr ?? _missionFr,
  dedicated: dedicated ?? _dedicated,
  dedicatedFr: dedicatedFr ?? _dedicatedFr,
  categoryId: categoryId ?? _categoryId,
  subCategoryId: subCategoryId ?? _subCategoryId,
  number: number ?? _number,
  icon: icon ?? _icon,
  status: status ?? _status,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  categoryJson: categoryJson ?? _categoryJson,
  subCategoryJson: subCategoryJson ?? _subCategoryJson,
);
  num? get id => _id;
  String? get type => _type;
  String? get name => _name;
  String? get nameFr => _nameFr;
  String? get mission => _mission;
  String? get missionFr => _missionFr;
  String? get dedicated => _dedicated;
  String? get dedicatedFr => _dedicatedFr;
  String? get categoryId => _categoryId;
  dynamic get subCategoryId => _subCategoryId;
  num? get number => _number;
  String? get icon => _icon;
  String? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  dynamic get categoryJson => _categoryJson;
  dynamic get subCategoryJson => _subCategoryJson;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['type'] = _type;
    map['name'] = _name;
    map['nameFr'] = _nameFr;
    map['mission'] = _mission;
    map['missionFr'] = _missionFr;
    map['dedicated'] = _dedicated;
    map['dedicatedFr'] = _dedicatedFr;
    map['categoryId'] = _categoryId;
    map['subCategoryId'] = _subCategoryId;
    map['number'] = _number;
    map['icon'] = _icon;
    map['status'] = _status;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['categoryJson'] = _categoryJson;
    map['subCategoryJson'] = _subCategoryJson;
    return map;
  }

}