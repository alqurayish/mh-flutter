import 'dart:convert';

class Employee {
  Employee({
    this.id,
    this.name,
    this.email,
    this.userIdNumber,
    this.phoneNumber,
    this.role,
    this.profilePicture,
    this.cv,
    this.verified,
    this.active,
    this.employee,
    this.gender,
    this.dateOfBirth,
    this.presentAddress,
    this.permanentAddress,
    this.higherEducation,
    this.licensesNo,
    this.emmergencyContact,
    this.countryName,
    this.sourceFrom,
    this.employeeExperience,
    this.rating,
    this.totalWorkingHour,
    this.isReferPerson,
    this.isHired,
    this.hiredByRestaurantName,
    this.hiredByRestaurantAddress,
    this.hiredFromDate,
    this.hiredToDate,
    this.hiredBy,
    this.isMhEmployee,
    this.languages,
    this.clientDiscount,
    this.hiredByLat,
    this.hiredByLong,
    this.iat,
    this.exp,
  });

  final String? id;
  final String? name;
  final String? email;
  final String? userIdNumber;
  final String? phoneNumber;
  final String? role;
  final String? profilePicture;
  final String? cv;
  final bool? verified;
  final bool? active;
  final bool? employee;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? presentAddress;
  final String? permanentAddress;
  final String? higherEducation;
  final String? licensesNo;
  final String? emmergencyContact;
  final String? countryName;
  final String? sourceFrom;
  final int? employeeExperience;
  final int? rating;
  final int? totalWorkingHour;
  final bool? isReferPerson;
  final bool? isHired;
  final DateTime? hiredFromDate;
  final DateTime? hiredToDate;
  final String? hiredBy;
  final String? hiredByRestaurantName;
  final String? hiredByRestaurantAddress;
  final bool? isMhEmployee;
  final List<String>? languages;
  final int? clientDiscount;
  final String? hiredByLat;
  final String? hiredByLong;
  final int? iat;
  final int? exp;

  factory Employee.fromRawJson(String str) => Employee.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    userIdNumber: json["userIdNumber"],
    phoneNumber: json["phoneNumber"],
    role: json["role"],
    profilePicture: json["profilePicture"],
    cv: json["cv"],
    verified: json["verified"],
    active: json["active"],
    employee: json["employee"],
    gender: json["gender"],
    dateOfBirth: json["dateOfBirth"] == null ? null : DateTime.parse(json["dateOfBirth"]),
    presentAddress: json["presentAddress"],
    permanentAddress: json["permanentAddress"],
    higherEducation: json["higherEducation"],
    licensesNo: json["licensesNo"],
    emmergencyContact: json["emmergencyContact"],
    countryName: json["countryName"],
    sourceFrom: json["sourceFrom"],
    employeeExperience: json["employeeExperience"],
    rating: json["rating"],
    totalWorkingHour: json["totalWorkingHour"],
    isReferPerson: json["isReferPerson"],
    isHired: json["isHired"],
    hiredFromDate: json["hiredFromDate"] == null ? null : DateTime.parse(json["hiredFromDate"]),
    hiredToDate: json["hiredToDate"] == null ? null : DateTime.parse(json["hiredToDate"]),
    hiredBy: json["hiredBy"],
    hiredByRestaurantName: json["hiredByRestaurantName"],
    hiredByRestaurantAddress: json["hiredByRestaurantAddress"],
    isMhEmployee: json["isMhEmployee"],
    languages: json["languages"] == null ? [] : List<String>.from(json["languages"]!.map((x) => x)),
    clientDiscount: json["clientDiscount"],
    hiredByLat: json["hiredByLat"],
    hiredByLong: json["hiredByLong"],
    iat: json["iat"],
    exp: json["exp"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "userIdNumber": userIdNumber,
    "phoneNumber": phoneNumber,
    "role": role,
    "profilePicture": profilePicture,
    "cv": cv,
    "verified": verified,
    "active": active,
    "employee": employee,
    "gender": gender,
    "dateOfBirth": dateOfBirth?.toIso8601String(),
    "presentAddress": presentAddress,
    "permanentAddress": permanentAddress,
    "higherEducation": higherEducation,
    "licensesNo": licensesNo,
    "emmergencyContact": emmergencyContact,
    "countryName": countryName,
    "sourceFrom": sourceFrom,
    "employeeExperience": employeeExperience,
    "rating": rating,
    "totalWorkingHour": totalWorkingHour,
    "isReferPerson": isReferPerson,
    "isHired": isHired,
    "hiredByRestaurantName": hiredByRestaurantName,
    "hiredByRestaurantAddress": hiredByRestaurantAddress,
    "hiredFromDate": hiredFromDate?.toIso8601String(),
    "hiredToDate": hiredToDate?.toIso8601String(),
    "hiredBy": hiredBy,
    "isMhEmployee": isMhEmployee,
    "languages": languages == null ? [] : List<dynamic>.from(languages!.map((x) => x)),
    "clientDiscount": clientDiscount,
    "hiredByLat": hiredByLat,
    "hiredByLong": hiredByLong,
    "iat": iat,
    "exp": exp,
  };
}
