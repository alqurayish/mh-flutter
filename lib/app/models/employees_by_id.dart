import 'dart:convert';

class Employees {
  Employees({
    this.status,
    this.statusCode,
    this.message,
    this.total,
    this.count,
    this.next,
    this.users,
  });

  final String? status;
  final int? statusCode;
  final String? message;
  final int? total;
  final int? count;
  final int? next;
  final List<Employee>? users;

  factory Employees.fromRawJson(String str) => Employees.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Employees.fromJson(Map<String, dynamic> json) => Employees(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    total: json["total"],
    count: json["count"],
    next: json["next"],
    users: json["users"] == null ? [] : List<Employee>.from(json["users"]!.map((x) => Employee.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "total": total,
    "count": count,
    "next": next,
    "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x.toJson())),
  };
}

class Employee {
  Employee({
    this.id,
    this.name,
    this.gender,
    this.dateOfBirth,
    this.userIdNumber,
    this.email,
    this.phoneNumber,
    this.presentAddress,
    this.permanentAddress,
    this.language,
    this.higherEducation,
    this.licensesNo,
    this.emmergencyContact,
    this.countryName,
    this.password,
    this.sourceFrom,
    this.referPersonName,
    this.emailVerified,
    this.phoneNumberVerified,
    this.employee,
    this.role,
    this.active,
    this.verified,
    this.noOfEmployee,
    this.employeeExperience,
    this.rating,
    this.totalWorkingHour,
    this.certificates,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.position,
    this.certificationsName,
    this.restaurantName,
    this.restaurantAddress,
    this.client,
  });

  final String? id;
  final String? name;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? userIdNumber;
  final String? email;
  final String? phoneNumber;
  final String? presentAddress;
  final String? permanentAddress;
  final List<String>? language;
  final String? higherEducation;
  final String? licensesNo;
  final String? emmergencyContact;
  final String? countryName;
  final String? password;
  final String? sourceFrom;
  final String? referPersonName;
  final bool? emailVerified;
  final bool? phoneNumberVerified;
  final bool? employee;
  final String? role;
  final bool? active;
  final bool? verified;
  final int? noOfEmployee;
  final int? employeeExperience;
  final int? rating;
  final int? totalWorkingHour;
  final List<dynamic>? certificates;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? position;
  final String? certificationsName;
  final String? restaurantName;
  final String? restaurantAddress;
  final bool? client;

  factory Employee.fromRawJson(String str) => Employee.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json["_id"],
    name: json["name"],
    gender: json["gender"],
    dateOfBirth: json["dateOfBirth"] == null ? null : DateTime.parse(json["dateOfBirth"]),
    userIdNumber: json["userIdNumber"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    presentAddress: json["presentAddress"],
    permanentAddress: json["permanentAddress"],
    language: json["language"] == null ? [] : List<String>.from(json["language"]!.map((x) => x)),
    higherEducation: json["higherEducation"],
    licensesNo: json["licensesNo"],
    emmergencyContact: json["emmergencyContact"],
    countryName: json["countryName"],
    password: json["password"],
    sourceFrom: json["sourceFrom"],
    referPersonName: json["referPersonName"],
    emailVerified: json["emailVerified"],
    phoneNumberVerified: json["phoneNumberVerified"],
    employee: json["employee"],
    role: json["role"],
    active: json["active"],
    verified: json["verified"],
    noOfEmployee: json["noOfEmployee"],
    employeeExperience: json["employeeExperience"],
    rating: json["rating"],
    totalWorkingHour: json["totalWorkingHour"],
    certificates: json["certificates"] == null ? [] : List<dynamic>.from(json["certificates"]!.map((x) => x)),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    position: json["position"],
    certificationsName: json["certificationsName"],
    restaurantName: json["restaurantName"],
    restaurantAddress: json["restaurantAddress"],
    client: json["client"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "gender": gender,
    "dateOfBirth": dateOfBirth?.toIso8601String(),
    "userIdNumber": userIdNumber,
    "email": email,
    "phoneNumber": phoneNumber,
    "presentAddress": presentAddress,
    "permanentAddress": permanentAddress,
    "language": language == null ? [] : List<dynamic>.from(language!.map((x) => x)),
    "higherEducation": higherEducation,
    "licensesNo": licensesNo,
    "emmergencyContact": emmergencyContact,
    "countryName": countryName,
    "password": password,
    "sourceFrom": sourceFrom,
    "referPersonName": referPersonName,
    "emailVerified": emailVerified,
    "phoneNumberVerified": phoneNumberVerified,
    "employee": employee,
    "role": role,
    "active": active,
    "verified": verified,
    "noOfEmployee": noOfEmployee,
    "employeeExperience": employeeExperience,
    "rating": rating,
    "totalWorkingHour": totalWorkingHour,
    "certificates": certificates == null ? [] : List<dynamic>.from(certificates!.map((x) => x)),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "position": position,
    "certificationsName": certificationsName,
    "restaurantName": restaurantName,
    "restaurantAddress": restaurantAddress,
    "client": client,
  };
}
