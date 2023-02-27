import 'dart:convert';

class Client {
  Client({
    this.id,
    this.email,
    this.userIdNumber,
    this.phoneNumber,
    this.role,
    this.verified,
    this.active,
    this.client,
    this.sourceFrom,
    this.restaurantName,
    this.restaurantAddress,
    this.rating,
    this.iat,
    this.exp,
  });

  final String? id;
  final String? email;
  final String? userIdNumber;
  final String? phoneNumber;
  final String? role;
  final bool? verified;
  final bool? active;
  final bool? client;
  final String? sourceFrom;
  final String? restaurantName;
  final String? restaurantAddress;
  final int? rating;
  final int? iat;
  final int? exp;

  factory Client.fromRawJson(String str) => Client.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: json["_id"],
    email: json["email"],
    userIdNumber: json["userIdNumber"],
    phoneNumber: json["phoneNumber"],
    role: json["role"],
    verified: json["verified"],
    active: json["active"],
    client: json["client"],
    sourceFrom: json["sourceFrom"],
    restaurantName: json["restaurantName"],
    restaurantAddress: json["restaurantAddress"],
    rating: json["rating"],
    iat: json["iat"],
    exp: json["exp"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "userIdNumber": userIdNumber,
    "phoneNumber": phoneNumber,
    "role": role,
    "verified": verified,
    "active": active,
    "client": client,
    "sourceFrom": sourceFrom,
    "restaurantName": restaurantName,
    "restaurantAddress": restaurantAddress,
    "rating": rating,
    "iat": iat,
    "exp": exp,
  };
}
