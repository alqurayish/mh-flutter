import 'dart:convert';

class DailyCheckinCheckoutDetails {
  DailyCheckinCheckoutDetails({
    this.status,
    this.statusCode,
    this.message,
    this.details,
  });

  final String? status;
  final int? statusCode;
  final String? message;
  final Details? details;

  factory DailyCheckinCheckoutDetails.fromRawJson(String str) => DailyCheckinCheckoutDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DailyCheckinCheckoutDetails.fromJson(Map<String, dynamic> json) => DailyCheckinCheckoutDetails(
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
    this.checkIn,
    this.checkOut,
    this.checkInTime,
    this.emmergencyCheckIn,
    this.emmergencyCheckOut,
    this.checkInLat,
    this.checkInLong,
    this.id,
  });

  final String? hiredBy;
  final int? checkInDistance;
  final bool? checkIn;
  final bool? checkOut;
  final String? checkInTime;
  final bool? emmergencyCheckIn;
  final bool? emmergencyCheckOut;
  final String? checkInLat;
  final String? checkInLong;
  final String? id;

  factory CheckInCheckOutDetails.fromRawJson(String str) => CheckInCheckOutDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CheckInCheckOutDetails.fromJson(Map<String, dynamic> json) => CheckInCheckOutDetails(
    hiredBy: json["hiredBy"],
    checkInDistance: json["checkInDistance"],
    checkIn: json["checkIn"],
    checkOut: json["checkOut"],
    checkInTime: json["checkInTime"],
    emmergencyCheckIn: json["emmergencyCheckIn"],
    emmergencyCheckOut: json["emmergencyCheckOut"],
    checkInLat: json["checkInLat"],
    checkInLong: json["checkInLong"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "hiredBy": hiredBy,
    "checkInDistance": checkInDistance,
    "checkIn": checkIn,
    "checkOut": checkOut,
    "checkInTime": checkInTime,
    "emmergencyCheckIn": emmergencyCheckIn,
    "emmergencyCheckOut": emmergencyCheckOut,
    "checkInLat": checkInLat,
    "checkInLong": checkInLong,
    "_id": id,
  };
}

class EmployeeDetails {
  EmployeeDetails({
    this.employeeId,
    this.name,
    this.positionId,
    this.presentAddress,
    this.permanentAddress,
    this.employeeExperience,
    this.rating,
    this.totalWorkingHour,
    this.hourlyRate,
    this.fromDate,
    this.toDate,
    this.profilePicture,
    this.id,
  });

  final String? employeeId;
  final String? name;
  final String? positionId;
  final String? presentAddress;
  final String? permanentAddress;
  final int? employeeExperience;
  final int? rating;
  final int? totalWorkingHour;
  final int? hourlyRate;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? profilePicture;
  final String? id;

  factory EmployeeDetails.fromRawJson(String str) => EmployeeDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EmployeeDetails.fromJson(Map<String, dynamic> json) => EmployeeDetails(
    employeeId: json["employeeId"],
    name: json["name"],
    positionId: json["positionId"],
    presentAddress: json["presentAddress"],
    permanentAddress: json["permanentAddress"],
    employeeExperience: json["employeeExperience"],
    rating: json["rating"],
    totalWorkingHour: json["totalWorkingHour"],
    hourlyRate: json["hourlyRate"],
    fromDate: json["fromDate"] == null ? null : DateTime.parse(json["fromDate"]),
    toDate: json["toDate"] == null ? null : DateTime.parse(json["toDate"]),
    profilePicture: json["profilePicture"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "employeeId": employeeId,
    "name": name,
    "positionId": positionId,
    "presentAddress": presentAddress,
    "permanentAddress": permanentAddress,
    "employeeExperience": employeeExperience,
    "rating": rating,
    "totalWorkingHour": totalWorkingHour,
    "hourlyRate": hourlyRate,
    "fromDate": fromDate?.toIso8601String(),
    "toDate": toDate?.toIso8601String(),
    "profilePicture": profilePicture,
    "_id": id,
  };
}

class RestaurantDetails {
  RestaurantDetails({
    this.hiredBy,
    this.id,
  });

  final String? hiredBy;
  final String? id;

  factory RestaurantDetails.fromRawJson(String str) => RestaurantDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RestaurantDetails.fromJson(Map<String, dynamic> json) => RestaurantDetails(
    hiredBy: json["hiredBy"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "hiredBy": hiredBy,
    "_id": id,
  };
}
