import 'dart:convert';

class TodayCheckInOutDetails {
  TodayCheckInOutDetails({
    this.status,
    this.statusCode,
    this.message,
    this.details,
  });

  final String? status;
  final int? statusCode;
  final String? message;
  final Details? details;

  factory TodayCheckInOutDetails.fromRawJson(String str) => TodayCheckInOutDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TodayCheckInOutDetails.fromJson(Map<String, dynamic> json) => TodayCheckInOutDetails(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    details: json["details"] == null ? null : Details.fromJson(json["details"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "details": details?.toJson(),
  };
}

class Details {
  Details({
    this.id,
    this.employeeId,
    this.hiredBy,
    this.employeeDetails,
    this.restaurantDetails,
    this.checkInCheckOutDetails,
    this.fromDate,
    this.toDate,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? id;
  final String? employeeId;
  final String? hiredBy;
  final EmployeeDetails? employeeDetails;
  final RestaurantDetails? restaurantDetails;
  final CheckInCheckOutDetails? checkInCheckOutDetails;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Details.fromRawJson(String str) => Details.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    id: json["_id"],
    employeeId: json["employeeId"],
    hiredBy: json["hiredBy"],
    employeeDetails: json["employeeDetails"] == null ? null : EmployeeDetails.fromJson(json["employeeDetails"]),
    restaurantDetails: json["restaurantDetails"] == null ? null : RestaurantDetails.fromJson(json["restaurantDetails"]),
    checkInCheckOutDetails: json["checkInCheckOutDetails"] == null ? null : CheckInCheckOutDetails.fromJson(json["checkInCheckOutDetails"]),
    fromDate: json["fromDate"] == null ? null : DateTime.parse(json["fromDate"]),
    toDate: json["toDate"] == null ? null : DateTime.parse(json["toDate"]),
    createdBy: json["createdBy"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "employeeId": employeeId,
    "hiredBy": hiredBy,
    "employeeDetails": employeeDetails?.toJson(),
    "restaurantDetails": restaurantDetails?.toJson(),
    "checkInCheckOutDetails": checkInCheckOutDetails?.toJson(),
    "fromDate": fromDate?.toIso8601String(),
    "toDate": toDate?.toIso8601String(),
    "createdBy": createdBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class CheckInCheckOutDetails {
  CheckInCheckOutDetails({
    this.hiredBy,
    this.checkInDistance,
    this.checkOutDistance,
    this.breakTime,
    this.checkIn,
    this.checkOut,
    this.checkInTime,
    this.checkOutTime,
    this.emmergencyCheckIn,
    this.emmergencyCheckOut,
    this.checkInLat,
    this.checkInLong,
    this.checkOutLat,
    this.checkOutLong,
    this.id,
  });

  final String? hiredBy;
  final int? checkInDistance;
  final int? checkOutDistance;
  final int? breakTime;
  final bool? checkIn;
  final bool? checkOut;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final bool? emmergencyCheckIn;
  final bool? emmergencyCheckOut;
  final String? checkInLat;
  final String? checkInLong;
  final String? checkOutLat;
  final String? checkOutLong;
  final String? id;

  factory CheckInCheckOutDetails.fromRawJson(String str) => CheckInCheckOutDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CheckInCheckOutDetails.fromJson(Map<String, dynamic> json) => CheckInCheckOutDetails(
    hiredBy: json["hiredBy"],
    checkInDistance: json["checkInDistance"],
    checkOutDistance: json["checkOutDistance"],
    breakTime: json["breakTime"],
    checkIn: json["checkIn"],
    checkOut: json["checkOut"],
    checkInTime: json["checkInTime"] == null ? null : DateTime.parse(json["checkInTime"]),
    checkOutTime: json["checkOutTime"] == null ? null : DateTime.parse(json["checkOutTime"]),
    emmergencyCheckIn: json["emmergencyCheckIn"],
    emmergencyCheckOut: json["emmergencyCheckOut"],
    checkInLat: json["checkInLat"],
    checkInLong: json["checkInLong"],
    checkOutLat: json["checkOutLat"],
    checkOutLong: json["checkOutLong"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "hiredBy": hiredBy,
    "checkInDistance": checkInDistance,
    "checkOutDistance": checkOutDistance,
    "breakTime": breakTime,
    "checkIn": checkIn,
    "checkOut": checkOut,
    "checkInTime": checkInTime?.toIso8601String(),
    "checkOutTime": checkOutTime?.toIso8601String(),
    "emmergencyCheckIn": emmergencyCheckIn,
    "emmergencyCheckOut": emmergencyCheckOut,
    "checkInLat": checkInLat,
    "checkInLong": checkInLong,
    "checkOutLat": checkOutLat,
    "checkOutLong": checkOutLong,
    "_id": id,
  };
}

class EmployeeDetails {
  EmployeeDetails({
    this.employeeId,
    this.name,
    this.positionId,
    this.rating,
    this.totalWorkingHour,
    this.hourlyRate,
    this.fromDate,
    this.toDate,
    this.id,
  });

  final String? employeeId;
  final String? name;
  final String? positionId;
  final int? rating;
  final int? totalWorkingHour;
  final int? hourlyRate;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? id;

  factory EmployeeDetails.fromRawJson(String str) => EmployeeDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EmployeeDetails.fromJson(Map<String, dynamic> json) => EmployeeDetails(
    employeeId: json["employeeId"],
    name: json["name"],
    positionId: json["positionId"],
    rating: json["rating"],
    totalWorkingHour: json["totalWorkingHour"],
    hourlyRate: json["hourlyRate"],
    fromDate: json["fromDate"] == null ? null : DateTime.parse(json["fromDate"]),
    toDate: json["toDate"] == null ? null : DateTime.parse(json["toDate"]),
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "employeeId": employeeId,
    "name": name,
    "positionId": positionId,
    "rating": rating,
    "totalWorkingHour": totalWorkingHour,
    "hourlyRate": hourlyRate,
    "fromDate": fromDate?.toIso8601String(),
    "toDate": toDate?.toIso8601String(),
    "_id": id,
  };
}

class RestaurantDetails {
  RestaurantDetails({
    this.hiredBy,
    this.restaurantName,
    this.restaurantAddress,
    this.lat,
    this.long,
    this.id,
  });

  final String? hiredBy;
  final String? restaurantName;
  final String? restaurantAddress;
  final String? lat;
  final String? long;
  final String? id;

  factory RestaurantDetails.fromRawJson(String str) => RestaurantDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RestaurantDetails.fromJson(Map<String, dynamic> json) => RestaurantDetails(
    hiredBy: json["hiredBy"],
    restaurantName: json["restaurantName"],
    restaurantAddress: json["restaurantAddress"],
    lat: json["lat"],
    long: json["long"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "hiredBy": hiredBy,
    "restaurantName": restaurantName,
    "restaurantAddress": restaurantAddress,
    "lat": lat,
    "long": long,
    "_id": id,
  };
}
