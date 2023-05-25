import 'dart:convert';

class ClientInvoice {
  final String? status;
  final int? statusCode;
  final String? message;
  final int? total;
  final int? count;
  final int? next;
  final List<Invoice>? invoices;

  ClientInvoice({
    this.status,
    this.statusCode,
    this.message,
    this.total,
    this.count,
    this.next,
    this.invoices,
  });

  factory ClientInvoice.fromRawJson(String str) => ClientInvoice.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClientInvoice.fromJson(Map<String, dynamic> json) => ClientInvoice(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    total: json["total"],
    count: json["count"],
    next: json["next"],
    invoices: json["invoices"] == null ? [] : List<Invoice>.from(json["invoices"]!.map((x) => Invoice.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "total": total,
    "count": count,
    "next": next,
    "invoices": invoices == null ? [] : List<dynamic>.from(invoices!.map((x) => x.toJson())),
  };
}

class Invoice {
  final String? id;
  final int? totalEmployee;
  final double? amount;
  final DateTime? fromWeekDate;
  final DateTime? toWeekDate;
  final DateTime? invoiceDate;
  final String? invoiceNumber;
  final String? status;
  final bool? active;
  final String? clientId;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Invoice({
    this.id,
    this.totalEmployee,
    this.amount,
    this.fromWeekDate,
    this.toWeekDate,
    this.invoiceDate,
    this.invoiceNumber,
    this.status,
    this.active,
    this.clientId,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Invoice.fromRawJson(String str) => Invoice.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
    id: json["_id"],
    totalEmployee: json["totalEmployee"],
    amount: double.parse(json["amount"].toString()),
    fromWeekDate: json["fromWeekDate"] == null ? null : DateTime.parse(json["fromWeekDate"]),
    toWeekDate: json["toWeekDate"] == null ? null : DateTime.parse(json["toWeekDate"]),
    invoiceDate: json["invoiceDate"] == null ? null : DateTime.parse(json["invoiceDate"]),
    invoiceNumber: json["invoiceNumber"],
    status: json["status"],
    active: json["active"],
    clientId: json["clientId"],
    createdBy: json["createdBy"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "totalEmployee": totalEmployee,
    "amount": amount,
    "fromWeekDate": fromWeekDate?.toIso8601String(),
    "toWeekDate": toWeekDate?.toIso8601String(),
    "invoiceDate": invoiceDate?.toIso8601String(),
    "invoiceNumber": invoiceNumber,
    "status": status,
    "active": active,
    "clientId": clientId,
    "createdBy": createdBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
