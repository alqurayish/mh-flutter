import 'dart:convert';

class ClientRegistrationResponse {
  ClientRegistrationResponse({
    this.status,
    this.statusCode,
    this.message,
    this.token,
  });

  final String? status;
  final int? statusCode;
  final String? message;
  final String? token;

  factory ClientRegistrationResponse.fromRawJson(String str) =>
      ClientRegistrationResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClientRegistrationResponse.fromJson(Map<String, dynamic> json) =>
      ClientRegistrationResponse(
        status: json["status"],
        statusCode: json["statusCode"],
        message: json["message"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "message": message,
        "token": token,
      };
}
