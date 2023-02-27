import 'dart:convert';

class Sources {
  Sources({
    this.status,
    this.statusCode,
    this.message,
    this.total,
    this.count,
    this.next,
    this.sources,
  });

  final String? status;
  final int? statusCode;
  final String? message;
  final int? total;
  final int? count;
  final int? next;
  final List<Source>? sources;

  factory Sources.fromRawJson(String str) => Sources.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sources.fromJson(Map<String, dynamic> json) => Sources(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    total: json["total"],
    count: json["count"],
    next: json["next"],
    sources: json["sources"] == null ? [] : List<Source>.from(json["sources"]!.map((x) => Source.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "total": total,
    "count": count,
    "next": next,
    "sources": sources == null ? [] : List<dynamic>.from(sources!.map((x) => x.toJson())),
  };
}

class Source {
  Source({
    required this.id,
    required this.name,
    required this.active,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String id;
  final String name;
  final bool active;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  factory Source.fromRawJson(String str) => Source.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Source.fromJson(Map<String, dynamic> json) => Source(
    id: json["_id"],
    name: json["name"],
    active: json["active"],
    createdBy: json["createdBy"]!,
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "active": active,
    "createdBy": createdBy,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}