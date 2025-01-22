
import 'dart:convert';

TypingCheck typingCheckFromJson(String str) => TypingCheck.fromJson(json.decode(str));

String typingCheckToJson(TypingCheck data) => json.encode(data.toJson());

class TypingCheck {
  int? id;
  String? firstName;
  String? lastName;
  String? profilePicture;
  int? typing;

  TypingCheck({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.typing,
  });

  factory TypingCheck.fromJson(Map<String, dynamic> json) => TypingCheck(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    profilePicture: json["profile_picture"],
    typing: json["typing"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "profile_picture": profilePicture,
    "typing": typing,
  };
}
