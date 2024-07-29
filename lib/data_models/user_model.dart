///
/// Created by Auro on 24/06/24 at 9:24 pm
///

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

UserDatum userFromJson(String str) => UserDatum.fromJson(json.decode(str));

String userToJson(UserDatum data) => json.encode(data.toJson());

class UserDatum {
  String? email;
  String? password;
  String? name;
  String? uid;

  UserDatum({
    this.email,
    this.password,
    this.name,
    this.uid,
  });

  factory UserDatum.fromJson(Map<String, dynamic> json) => UserDatum(
        email: json["email"],
        password: json["password"],
        name: json["name"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "name": name,
        "uid": uid,
      };
}
