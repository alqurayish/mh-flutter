import 'dart:convert';

class ShortlistedEmployees {
  ShortlistedEmployees({
    this.status,
    this.statusCode,
    this.message,
    this.total,
    this.count,
    this.next,
    this.shortList,
  });

  final String? status;
  final int? statusCode;
  final String? message;
  final int? total;
  final int? count;
  final int? next;
  final List<ShortList>? shortList;

  factory ShortlistedEmployees.fromRawJson(String str) => ShortlistedEmployees.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ShortlistedEmployees.fromJson(Map<String, dynamic> json) => ShortlistedEmployees(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    total: json["total"],
    count: json["count"],
    next: json["next"],
    shortList: json["shortList"] == null ? [] : List<ShortList>.from(json["shortList"]!.map((x) => ShortList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "total": total,
    "count": count,
    "next": next,
    "shortList": shortList == null ? [] : List<dynamic>.from(shortList!.map((x) => x.toJson())),
  };
}

class ShortList {
  ShortList({
    this.id,
    this.employeeId,
    this.employeeName,
    this.employeeRating,
    this.positionId,
    this.feeAmount,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.introductionFee,
    this.fromDate,
    this.toDate,
  });

  final String? id;
  final String? employeeId;
  final String? employeeName;
  final int? employeeRating;
  final String? positionId;
  final int? feeAmount;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final int? introductionFee;
  final DateTime? fromDate;
  final DateTime? toDate;

  factory ShortList.fromRawJson(String str) => ShortList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ShortList.fromJson(Map<String, dynamic> json) => ShortList(
    id: json["_id"],
    employeeId: json["employeeId"],
    employeeName: json["employeeName"],
    employeeRating: json["employeeRating"],
    positionId: json["positionId"],
    feeAmount: json["feeAmount"],
    createdBy: json["createdBy"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    introductionFee: json["introductionFee"],
    fromDate: json["fromDate"] == null ? null : DateTime.parse(json["fromDate"]),
    toDate: json["toDate"] == null ? null : DateTime.parse(json["toDate"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "employeeId": employeeId,
    "employeeName": employeeName,
    "employeeRating": employeeRating,
    "positionId": positionId,
    "feeAmount": feeAmount,
    "createdBy": createdBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "introductionFee": introductionFee,
    "fromDate": fromDate?.toIso8601String(),
    "toDate": toDate?.toIso8601String(),
  };
}
