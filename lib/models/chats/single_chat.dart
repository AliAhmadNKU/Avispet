class SingleChat {
  int? onlineStatus;
  String? lastOnlineTime;
  String? theme;
  List<Message>? message;

  SingleChat(
      {this.onlineStatus, this.lastOnlineTime, this.theme, this.message});

  SingleChat.fromJson(Map<String, dynamic> json) {
    onlineStatus = json['online_status'];
    lastOnlineTime = json['lastOnlineTime'];
    theme = json['theme'];
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['online_status'] = this.onlineStatus;
    data['lastOnlineTime'] = this.lastOnlineTime;
    data['theme'] = this.theme;
    if (this.message != null) {
      data['message'] = this.message!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  int? id;
  int? senderId;
  int? receiverId;
  int? chatConstantId;
  int? groupId;
  String? message;
  int? readStatus;
  int? messageType;
  int? deletedId;
  int? postId;
  int? created;
  int? updated;
  String? recieverName;
  String? senderImage;
  String? senderName;
  String? recieverImage;
  String? mediaUrl;
  PostData? postData;

  Message(
      {this.id,
        this.senderId,
        this.receiverId,
        this.chatConstantId,
        this.groupId,
        this.message,
        this.readStatus,
        this.messageType,
        this.deletedId,
        this.postId,
        this.created,
        this.updated,
        this.recieverName,
        this.senderImage,
        this.senderName,
        this.recieverImage,
        this.mediaUrl,
        this.postData});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    chatConstantId = json['chatConstantId'];
    groupId = json['groupId'];
    message = json['message'];
    readStatus = json['readStatus'];
    messageType = json['messageType'];
    deletedId = json['deletedId'];
    postId = json['postId'];
    created = json['created'];
    updated = json['updated'];
    recieverName = json['recieverName'];
    senderImage = json['senderImage'];
    senderName = json['senderName'];
    recieverImage = json['recieverImage'];
    mediaUrl = json['mediaUrl'];
    postData = json['postData'] != null
        ? new PostData.fromJson(json['postData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['senderId'] = this.senderId;
    data['receiverId'] = this.receiverId;
    data['chatConstantId'] = this.chatConstantId;
    data['groupId'] = this.groupId;
    data['message'] = this.message;
    data['readStatus'] = this.readStatus;
    data['messageType'] = this.messageType;
    data['deletedId'] = this.deletedId;
    data['postId'] = this.postId;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['recieverName'] = this.recieverName;
    data['senderImage'] = this.senderImage;
    data['senderName'] = this.senderName;
    data['recieverImage'] = this.recieverImage;
    data['mediaUrl'] = this.mediaUrl;
    if (this.postData != null) {
      data['postData'] = this.postData!.toJson();
    }
    return data;
  }
}

class PostData {
  int? id;
  String? tagId;
  Null title;
  String? description;
  String? strongPoints;
  String? weakPoints;
  String? qualityOfPoop;
  String? appetite;
  String? digestion;
  String? price;
  String? brand;
  String? productName;
  String? weight;
  String? storeLink;
  String? createdAt;
  String? updatedAt;
  String? status;
  int? categoryId;
  int? subCategoryId;
  int? userId;
  int? animalId;
  Category? category;
  Category? subCategory;
  List<FeedImages>? feedImages;
  FavoriteFeed? favoriteFeed;
  User? user;
  Animal? animal;

  PostData(
      {this.id,
        this.tagId,
        this.title,
        this.description,
        this.strongPoints,
        this.weakPoints,
        this.qualityOfPoop,
        this.appetite,
        this.digestion,
        this.price,
        this.brand,
        this.productName,
        this.weight,
        this.storeLink,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.categoryId,
        this.subCategoryId,
        this.userId,
        this.animalId,
        this.category,
        this.subCategory,
        this.feedImages,
        this.favoriteFeed,
        this.user,
        this.animal});

  PostData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tagId = json['tagId'];
    title = json['title'];
    description = json['description'];
    strongPoints = json['strongPoints'];
    weakPoints = json['weakPoints'];
    qualityOfPoop = json['qualityOfPoop'];
    appetite = json['appetite'];
    digestion = json['digestion'];
    price = json['price'];
    brand = json['brand'];
    productName = json['productName'];
    weight = json['weight'];
    storeLink = json['storeLink'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    status = json['status'];
    categoryId = json['categoryId'];
    subCategoryId = json['subCategoryId'];
    userId = json['userId'];
    animalId = json['animalId'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    subCategory = json['sub_category'] != null
        ? new Category.fromJson(json['sub_category'])
        : null;
    if (json['feed_images'] != null) {
      feedImages = <FeedImages>[];
      json['feed_images'].forEach((v) {
        feedImages!.add(new FeedImages.fromJson(v));
      });
    }
    favoriteFeed = json['favorite_feed'] != null
        ? new FavoriteFeed.fromJson(json['favorite_feed'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    animal =
    json['animal'] != null ? new Animal.fromJson(json['animal']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tagId'] = this.tagId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['strongPoints'] = this.strongPoints;
    data['weakPoints'] = this.weakPoints;
    data['qualityOfPoop'] = this.qualityOfPoop;
    data['appetite'] = this.appetite;
    data['digestion'] = this.digestion;
    data['price'] = this.price;
    data['brand'] = this.brand;
    data['productName'] = this.productName;
    data['weight'] = this.weight;
    data['storeLink'] = this.storeLink;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['status'] = this.status;
    data['categoryId'] = this.categoryId;
    data['subCategoryId'] = this.subCategoryId;
    data['userId'] = this.userId;
    data['animalId'] = this.animalId;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.subCategory != null) {
      data['sub_category'] = this.subCategory!.toJson();
    }
    if (this.feedImages != null) {
      data['feed_images'] = this.feedImages!.map((v) => v.toJson()).toList();
    }
    if (this.favoriteFeed != null) {
      data['favorite_feed'] = this.favoriteFeed!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.animal != null) {
      data['animal'] = this.animal!.toJson();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? nameFr;

  Category({this.id, this.name, this.nameFr});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameFr = json['name_fr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_fr'] = this.nameFr;
    return data;
  }
}

class FeedImages {
  int? id;
  String? image;
  String? createdAt;
  String? updatedAt;
  int? feedId;

  FeedImages(
      {this.id, this.image, this.createdAt, this.updatedAt, this.feedId});

  FeedImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    feedId = json['feedId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['feedId'] = this.feedId;
    return data;
  }
}

class FavoriteFeed {
  int? id;
  String? createdAt;
  String? updatedAt;
  int? userId;
  int? feedId;

  FavoriteFeed(
      {this.id, this.createdAt, this.updatedAt, this.userId, this.feedId});

  FavoriteFeed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
    feedId = json['feedId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    data['feedId'] = this.feedId;
    return data;
  }
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? profilePicture;
  int? isOnline;

  User(
      {this.id,
        this.firstName,
        this.lastName,
        this.profilePicture,
        this.isOnline});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePicture = json['profile_picture'];
    isOnline = json['is_online'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_picture'] = this.profilePicture;
    data['is_online'] = this.isOnline;
    return data;
  }
}

class Animal {
  int? id;
  String? name;
  String? type;
  String? gender;
  String? image;
  String? dob;
  String? race;

  Animal(
      {this.id,
        this.name,
        this.type,
        this.gender,
        this.image,
        this.dob,
        this.race});

  Animal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    gender = json['gender'];
    image = json['image'];
    dob = json['dob'];
    race = json['race'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['gender'] = this.gender;
    data['image'] = this.image;
    data['dob'] = this.dob;
    data['race'] = this.race;
    return data;
  }
}
