// To parse this JSON data, do
//
//     final notificationResponseModel = notificationResponseModelFromJson(jsonString);

import 'dart:convert';

NotificationResponseModel notificationResponseModelFromJson(String str) =>
    NotificationResponseModel.fromJson(json.decode(str));

class NotificationResponseModel {
  final String? status;
  final int? statusCode;
  final int? total;
  final int? count;
  final List<NotificationModel>? notifications;

  NotificationResponseModel({
    this.status,
    this.statusCode,
    this.total,
    this.count,
    this.notifications,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) => NotificationResponseModel(
        status: json["status"],
        statusCode: json["statusCode"],
        total: json["total"],
        count: json["count"],
        notifications: json["notifications"] == null
            ? []
            : List<NotificationModel>.from(json["notifications"]!.map((x) => NotificationModel.fromJson(x))),
      );
}

class NotificationModel {
  final String? id;
  final String? notificationType;
  final String? text;
  final bool? employee;
  final bool? client;
  final bool? admin;
  final bool? readStatus;
  final bool? isClientHired;
  final bool? active;
  final String? userId;
  final String? clientId;
  final String? restaurantName;
  final String? restaurantAddress;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? fromTime;
  final String? toTime;
  final String? hiredStatus;
  final String? hiredByLat;
  final String? hiredByLong;

  NotificationModel(
      {this.id,
      this.notificationType,
      this.text,
      this.employee,
      this.client,
      this.admin,
      this.readStatus,
      this.isClientHired,
      this.active,
      this.userId,
      this.clientId,
      this.restaurantName,
      this.restaurantAddress,
      this.fromDate,
      this.toDate,
      this.fromTime,
      this.toTime,
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.hiredByLat,
      this.hiredByLong,
      this.hiredStatus});

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
      id: json["_id"],
      notificationType: json["notificationType"],
      text: json["text"],
      employee: json["employee"],
      client: json["client"],
      admin: json["admin"],
      readStatus: json["readStatus"],
      isClientHired: json["isClientHired"],
      active: json["active"],
      userId: json["userId"],
      clientId: json["clientId"],
      restaurantName: json["restaurantName"],
      restaurantAddress: json["restaurantAddress"],
      createdBy: json["createdBy"],
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      fromDate: json["fromDate"] == null ? null : DateTime.parse(json["fromDate"]),
      toDate: json["toDate"] == null ? null : DateTime.parse(json["toDate"]),
      fromTime: json["fromTime"],
      toTime: json["toTime"],
      hiredStatus: json["hiredStatus"],
      hiredByLat: json["hiredByLat"],
      hiredByLong: json["hiredByLong"]);
}
