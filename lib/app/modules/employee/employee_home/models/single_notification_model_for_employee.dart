// To parse this JSON data, do
//
//     final singleNotificationModelForEmployee = singleNotificationModelForEmployeeFromJson(jsonString);

import 'dart:convert';

import 'package:mh/app/modules/notifications/models/notification_response_model.dart';

SingleNotificationModelForEmployee singleNotificationModelForEmployeeFromJson(String str) =>
    SingleNotificationModelForEmployee.fromJson(json.decode(str));

class SingleNotificationModelForEmployee {
  final String? status;
  final int? statusCode;
  final String? message;
  final NotificationModel? details;

  SingleNotificationModelForEmployee({
    this.status,
    this.statusCode,
    this.message,
    this.details,
  });

  factory SingleNotificationModelForEmployee.fromJson(Map<String, dynamic> json) => SingleNotificationModelForEmployee(
        status: json["status"],
        statusCode: json["statusCode"],
        message: json["message"],
        details: json["details"] == null ? null : NotificationModel.fromJson(json["details"]),
      );
}
