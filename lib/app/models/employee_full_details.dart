import 'dart:convert';
import 'package:mh/app/models/employees_by_id.dart';

class EmployeeFullDetails {
  final String? status;
  final int? statusCode;
  final String? message;
  final Employee? details;

  EmployeeFullDetails({
    this.status,
    this.statusCode,
    this.message,
    this.details,
  });

  factory EmployeeFullDetails.fromRawJson(String str) => EmployeeFullDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EmployeeFullDetails.fromJson(Map<String, dynamic> json) => EmployeeFullDetails(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    details: json["details"] == null ? null : Employee.fromJson(json["details"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "details": details?.toJson(),
  };
}

/*class Details {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? name;
  final String? positionId;
  final String? positionName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? userIdNumber;
  final String? email;
  final String? phoneNumber;
  final String? bankName;
  final String? accountNumber;
  final String? routingNumber;
  final String? dressSize;
  final List<String>? languages;
  final List<dynamic>? certificates;
  final String? countryName;
  final bool? employee;
  final bool? client;
  final bool? admin;
  final bool? hr;
  final bool? marketing;
  final String? role;
  final bool? isReferPerson;
  final bool? isMhEmployee;
  final bool? isHired;
  final DateTime? hiredFromDate;
  final DateTime? hiredToDate;
  final String? hiredBy;
  final String? hiredByLat;
  final String? hiredByLong;
  final String? hiredByRestaurantName;
  final String? hiredByRestaurantAddress;
  final String? profilePicture;
  final String? cv;
  final bool? verified;
  final dynamic employeeExperience;
  final bool? active;
  final int? rating;
  final int? totalWorkingHour;
  final double? hourlyRate;
  final int? clientDiscount;
  final List<dynamic>? menuPermission;
  final String? licensesNo;
  final String? presentAddress;
  final String? permanentAddress;
  final String? higherEducation;
  final PushNotificationDetails? pushNotificationDetails;


  Details({
    this.id,
    this.firstName,
    this.lastName,
    this.name,
    this.positionId,
    this.positionName,
    this.gender,
    this.dateOfBirth,
    this.userIdNumber,
    this.email,
    this.phoneNumber,
    this.bankName,
    this.accountNumber,
    this.routingNumber,
    this.dressSize,
    this.languages,
    this.certificates,
    this.countryName,
    this.employee,
    this.client,
    this.admin,
    this.hr,
    this.marketing,
    this.role,
    this.isReferPerson,
    this.isMhEmployee,
    this.isHired,
    this.hiredFromDate,
    this.hiredToDate,
    this.hiredBy,
    this.hiredByLat,
    this.hiredByLong,
    this.hiredByRestaurantName,
    this.hiredByRestaurantAddress,
    this.profilePicture,
    this.cv,
    this.verified,
    this.employeeExperience,
    this.active,
    this.rating,
    this.totalWorkingHour,
    this.hourlyRate,
    this.clientDiscount,
    this.menuPermission,
    this.licensesNo,
    this.presentAddress,
    this.permanentAddress,
    this.higherEducation,
    this.pushNotificationDetails,
  });

  factory Details.fromRawJson(String str) => Details.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    id: json["_id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    name: json["name"],
    positionId: json["positionId"],
    positionName: json["positionName"],
    gender: json["gender"],
    dateOfBirth: json["dateOfBirth"] == null ? null : DateTime.parse(json["dateOfBirth"]),
    userIdNumber: json["userIdNumber"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    bankName: json["bankName"],
    accountNumber: json["accountNumber"],
    routingNumber: json["routingNumber"],
    dressSize: json["dressSize"],
    languages: json["languages"] == null ? [] : List<String>.from(json["languages"]!.map((x) => x)),
    certificates: json["certificates"] == null ? [] : List<dynamic>.from(json["certificates"]!.map((x) => x)),
    countryName: json["countryName"],
    employee: json["employee"],
    client: json["client"],
    admin: json["admin"],
    hr: json["hr"],
    marketing: json["marketing"],
    role: json["role"],
    isReferPerson: json["isReferPerson"],
    isMhEmployee: json["isMhEmployee"],
    isHired: json["isHired"],
    hiredFromDate: json["hiredFromDate"] == null ? null : DateTime.parse(json["hiredFromDate"]),
    hiredToDate: json["hiredToDate"] == null ? null : DateTime.parse(json["hiredToDate"]),
    hiredBy: json["hiredBy"],
    hiredByLat: json["hiredByLat"],
    hiredByLong: json["hiredByLong"],
    hiredByRestaurantName: json["hiredByRestaurantName"],
    hiredByRestaurantAddress: json["hiredByRestaurantAddress"],
    profilePicture: json["profilePicture"],
    cv: json["cv"],
    verified: json["verified"],
    employeeExperience: json["employeeExperience"],
    active: json["active"],
    rating: json["rating"],
    totalWorkingHour: json["totalWorkingHour"],
    hourlyRate: double.parse(json["hourlyRate"].toString()),
    clientDiscount: json["clientDiscount"],
    menuPermission: json["menuPermission"] == null ? [] : List<dynamic>.from(json["menuPermission"]!.map((x) => x)),
    licensesNo: json["licensesNo"],
    presentAddress: json["presentAddress"],
    permanentAddress: json["permanentAddress"],
    higherEducation: json["higherEducation"],
    pushNotificationDetails: json["pushNotificationDetails"] == null ? null : PushNotificationDetails.fromJson(json["pushNotificationDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firstName": firstName,
    "lastName": lastName,
    "name": name,
    "positionId": positionId,
    "positionName": positionName,
    "gender": gender,
    "dateOfBirth": dateOfBirth?.toIso8601String(),
    "userIdNumber": userIdNumber,
    "email": email,
    "phoneNumber": phoneNumber,
    "bankName": bankName,
    "accountNumber": accountNumber,
    "routingNumber": routingNumber,
    "dressSize": dressSize,
    "languages": languages == null ? [] : List<dynamic>.from(languages!.map((x) => x)),
    "certificates": certificates == null ? [] : List<dynamic>.from(certificates!.map((x) => x)),
    "countryName": countryName,
    "employee": employee,
    "client": client,
    "admin": admin,
    "hr": hr,
    "marketing": marketing,
    "role": role,
    "isReferPerson": isReferPerson,
    "isMhEmployee": isMhEmployee,
    "isHired": isHired,
    "hiredFromDate": hiredFromDate?.toIso8601String(),
    "hiredToDate": hiredToDate?.toIso8601String(),
    "hiredBy": hiredBy,
    "hiredByLat": hiredByLat,
    "hiredByLong": hiredByLong,
    "hiredByRestaurantName": hiredByRestaurantName,
    "hiredByRestaurantAddress": hiredByRestaurantAddress,
    "profilePicture": profilePicture,
    "cv": cv,
    "verified": verified,
    "employeeExperience": employeeExperience,
    "active": active,
    "rating": rating,
    "totalWorkingHour": totalWorkingHour,
    "hourlyRate": hourlyRate,
    "clientDiscount": clientDiscount,
    "menuPermission": menuPermission == null ? [] : List<dynamic>.from(menuPermission!.map((x) => x)),
    "licensesNo": licensesNo,
    "presentAddress": presentAddress,
    "permanentAddress": permanentAddress,
    "higherEducation": higherEducation,
    "pushNotificationDetails": pushNotificationDetails?.toJson(),
  };
}*/
