///
/// Created by Auro on 24/06/24 at 9:24 pm
///

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? email;
  String? password;
  String? name;
  String? uid;
  DateTime? createdAt;

  User({
    this.email,
    this.password,
    this.name,
    this.uid,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"],
        password: json["password"],
        name: json["name"],
        uid: json["uid"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "name": name,
        "uid": uid,
        "createdAt": createdAt?.toIso8601String(),
      };
}
