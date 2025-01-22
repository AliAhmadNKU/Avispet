class Gamification {
  bool? success;
  int? code;
  String? message;
  int totalBadgesEarn = 0;
  List<Data>? data;
  Metadata? mMetadata;

  Gamification(
      {this.success, this.code, this.message, this.data, this.mMetadata});

  Gamification.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    mMetadata = json['_metadata'] != null
        ? new Metadata.fromJson(json['_metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.mMetadata != null) {
      data['_metadata'] = this.mMetadata!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? type;
  String? name;
  String? nameFr;
  String? mission;
  String? missionFr;
  String? dedicated;
  String? dedicatedFr;
  String? categoryId;
  String? subCategoryId;
  int? number;
  String? icon;
  String? createdAt;
  String? updatedAt;
  String? status;
  List<CategoryJson>? categoryJson;
  List<CategoryJson>? subCategoryJson;
  int? isEarned;
  int? showProgressBar;
  int? startingPoint;
  int? currentPointoint;
  int? totalPoint;
  int? currentPoint;

  Data(
      {this.id,
      this.type,
      this.name,
      this.nameFr,
      this.mission,
      this.missionFr,
      this.dedicated,
      this.dedicatedFr,
      this.categoryId,
      this.subCategoryId,
      this.number,
      this.icon,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.categoryJson,
      this.subCategoryJson,
      this.isEarned,
      this.showProgressBar,
      this.startingPoint,
      this.currentPointoint,
      this.totalPoint,
      this.currentPoint});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    nameFr = json['nameFr'];
    mission = json['mission'];
    missionFr = json['missionFr'];
    dedicated = json['dedicated'];
    dedicatedFr = json['dedicatedFr'];
    categoryId = json['categoryId'];
    subCategoryId = json['subCategoryId'];
    number = json['number'];
    icon = json['icon'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    status = json['status'];
    if (json['categoryJson'] != null) {
      categoryJson = <CategoryJson>[];
      json['categoryJson'].forEach((v) {
        categoryJson!.add(new CategoryJson.fromJson(v));
      });
    }
    if (json['subCategoryJson'] != null) {
      subCategoryJson = <CategoryJson>[];
      json['subCategoryJson'].forEach((v) {
        subCategoryJson!.add(new CategoryJson.fromJson(v));
      });
    }
    isEarned = json['isEarned'];
    showProgressBar = json['showProgressBar'];
    startingPoint = json['startingPoint'];
    currentPointoint = json['currentPointoint'];
    totalPoint = json['totalPoint'];
    currentPoint = json['currentPoint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['nameFr'] = this.nameFr;
    data['mission'] = this.mission;
    data['missionFr'] = this.missionFr;
    data['dedicated'] = this.dedicated;
    data['dedicatedFr'] = this.dedicatedFr;
    data['categoryId'] = this.categoryId;
    data['subCategoryId'] = this.subCategoryId;
    data['number'] = this.number;
    data['icon'] = this.icon;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['status'] = this.status;
    if (this.categoryJson != null) {
      data['categoryJson'] = this.categoryJson!.map((v) => v.toJson()).toList();
    }
    if (this.subCategoryJson != null) {
      data['subCategoryJson'] =
          this.subCategoryJson!.map((v) => v.toJson()).toList();
    }
    data['isEarned'] = this.isEarned;
    data['showProgressBar'] = this.showProgressBar;
    data['startingPoint'] = this.startingPoint;
    data['currentPointoint'] = this.currentPointoint;
    data['totalPoint'] = this.totalPoint;
    data['currentPoint'] = this.currentPoint;
    return data;
  }
}

class CategoryJson {
  String? name;
  String? nameFr;

  CategoryJson({this.name, this.nameFr});

  CategoryJson.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameFr = json['nameFr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['nameFr'] = this.nameFr;
    return data;
  }
}

class Metadata {
  int? totalRecords;
  int? totalPages;
  List<RulesToEarn>? rulesToEarn;
  List<Levels>? levels;

  Metadata({this.totalRecords, this.totalPages, this.rulesToEarn, this.levels});

  Metadata.fromJson(Map<String, dynamic> json) {
    totalRecords = json['totalRecords'];
    totalPages = json['totalPages'];
    if (json['rulesToEarn'] != null) {
      rulesToEarn = <RulesToEarn>[];
      json['rulesToEarn'].forEach((v) {
        rulesToEarn!.add(new RulesToEarn.fromJson(v));
      });
    }
    if (json['levels'] != null) {
      levels = <Levels>[];
      json['levels'].forEach((v) {
        levels!.add(new Levels.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalRecords'] = this.totalRecords;
    data['totalPages'] = this.totalPages;
    if (this.rulesToEarn != null) {
      data['rulesToEarn'] = this.rulesToEarn!.map((v) => v.toJson()).toList();
    }
    if (this.levels != null) {
      data['levels'] = this.levels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RulesToEarn {
  String? name;
  String? nameFr;
  int? points;

  RulesToEarn({this.name, this.nameFr, this.points});

  RulesToEarn.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameFr = json['nameFr'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['nameFr'] = this.nameFr;
    data['points'] = this.points;
    return data;
  }
}

class Levels {
  int? id;
  String? name;
  String? nameFr;
  String? minPoints;
  String? maxPoints;
  String? createdAt;
  String? updatedAt;
  String? status;

  Levels(
      {this.id,
      this.name,
      this.nameFr,
      this.minPoints,
      this.maxPoints,
      this.createdAt,
      this.updatedAt,
      this.status});

  Levels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameFr = json['nameFr'];
    minPoints = json['minPoints'];
    maxPoints = json['maxPoints'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['nameFr'] = this.nameFr;
    data['minPoints'] = this.minPoints;
    data['maxPoints'] = this.maxPoints;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['status'] = this.status;
    return data;
  }
}
