import 'dart:convert';

class Employee {
  Employee({
    this.id,
    this.name,
    this.email,
    this.userIdNumber,
    this.phoneNumber,
    this.role,
    this.verified,
    this.active,
    this.employee,
    this.gender,
    this.dateOfBirth,
    this.presentAddress,
    this.permanentAddress,
    this.language,
    this.higherEducation,
    this.licensesNo,
    this.emmergencyContact,
    this.countryName,
    this.sourceFrom,
    this.employeeExperience,
    this.rating,
    this.totalWorkingHour,
    this.isReferPerson,
    this.iat,
    this.exp,
  });

  final String? id;
  final String? name;
  final String? email;
  final String? userIdNumber;
  final String? phoneNumber;
  final String? role;
  final bool? verified;
  final bool? active;
  final bool? employee;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? presentAddress;
  final String? permanentAddress;
  final List<String>? language;
  final String? higherEducation;
  final String? licensesNo;
  final String? emmergencyContact;
  final String? countryName;
  final String? sourceFrom;
  final int? employeeExperience;
  final int? rating;
  final int? totalWorkingHour;
  final bool? isReferPerson;
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
    verified: json["verified"],
    active: json["active"],
    employee: json["employee"],
    gender: json["gender"],
    dateOfBirth: json["dateOfBirth"] == null ? null : DateTime.parse(json["dateOfBirth"]),
    presentAddress: json["presentAddress"],
    permanentAddress: json["permanentAddress"],
    language: json["language"] == null ? [] : List<String>.from(json["language"]!.map((x) => x)),
    higherEducation: json["higherEducation"],
    licensesNo: json["licensesNo"],
    emmergencyContact: json["emmergencyContact"],
    countryName: json["countryName"],
    sourceFrom: json["sourceFrom"],
    employeeExperience: json["employeeExperience"],
    rating: json["rating"],
    totalWorkingHour: json["totalWorkingHour"],
    isReferPerson: json["isReferPerson"],
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
    "verified": verified,
    "active": active,
    "employee": employee,
    "gender": gender,
    "dateOfBirth": dateOfBirth?.toIso8601String(),
    "presentAddress": presentAddress,
    "permanentAddress": permanentAddress,
    "language": language == null ? [] : List<dynamic>.from(language!.map((x) => x)),
    "higherEducation": higherEducation,
    "licensesNo": licensesNo,
    "emmergencyContact": emmergencyContact,
    "countryName": countryName,
    "sourceFrom": sourceFrom,
    "employeeExperience": employeeExperience,
    "rating": rating,
    "totalWorkingHour": totalWorkingHour,
    "isReferPerson": isReferPerson,
    "iat": iat,
    "exp": exp,
  };
}
