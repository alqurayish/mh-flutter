import 'dart:convert';

import '../../../../models/employee_details.dart';

class HiredEmployeesByDate {
  HiredEmployeesByDate({
    this.status,
    this.statusCode,
    this.message,
    this.total,
    this.count,
    this.next,
    this.hiredHistories,
  });

  final String? status;
  final int? statusCode;
  final String? message;
  final int? total;
  final int? count;
  final int? next;
  final List<HiredHistory>? hiredHistories;

  factory HiredEmployeesByDate.fromRawJson(String str) => HiredEmployeesByDate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HiredEmployeesByDate.fromJson(Map<String, dynamic> json) => HiredEmployeesByDate(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    total: json["total"],
    count: json["count"],
    next: json["next"],
    hiredHistories: json["hiredHistories"] == null ? [] : List<HiredHistory>.from(json["hiredHistories"]!.map((x) => HiredHistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "total": total,
    "count": count,
    "next": next,
    "hiredHistories": hiredHistories == null ? [] : List<dynamic>.from(hiredHistories!.map((x) => x.toJson())),
  };
}

class HiredHistory {
  HiredHistory({
    this.id,
    this.employeeId,
    this.fromDate,
    this.toDate,
    this.employeeDetails,
    this.feeAmount,
    this.active,
    this.hiredBy,
    this.hiredDate,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? id;
  final String? employeeId;
  final DateTime? fromDate;
  final DateTime? toDate;
  final EmployeeDetails? employeeDetails;
  final int? feeAmount;
  final bool? active;
  final String? hiredBy;
  final DateTime? hiredDate;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory HiredHistory.fromRawJson(String str) => HiredHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HiredHistory.fromJson(Map<String, dynamic> json) => HiredHistory(
    id: json["_id"],
    employeeId: json["employeeId"],
    fromDate: json["fromDate"] == null ? null : DateTime.parse(json["fromDate"]),
    toDate: json["toDate"] == null ? null : DateTime.parse(json["toDate"]),
    employeeDetails: json["employeeDetails"] == null ? null : EmployeeDetails.fromJson(json["employeeDetails"]),
    feeAmount: json["feeAmount"],
    active: json["active"],
    hiredBy: json["hiredBy"],
    hiredDate: json["hiredDate"] == null ? null : DateTime.parse(json["hiredDate"]),
    createdBy: json["createdBy"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "employeeId": employeeId,
    "fromDate": fromDate?.toIso8601String(),
    "toDate": toDate?.toIso8601String(),
    "employeeDetails": employeeDetails?.toJson(),
    "feeAmount": feeAmount,
    "active": active,
    "hiredBy": hiredBy,
    "hiredDate": hiredDate?.toIso8601String(),
    "createdBy": createdBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
