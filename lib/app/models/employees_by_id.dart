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
    this.positionId,
    this.positionName,
    this.gender,
    this.dateOfBirth,
    this.userIdNumber,
    this.email,
    this.phoneNumber,
    this.presentAddress,
    this.permanentAddress,
    this.languages,
    this.higherEducation,
    this.licensesNo,
    this.emmergencyContact,
    this.skills,
    this.countryName,
    this.password,
    this.plainPassword,
    this.sourceId,
    this.sourceName,
    this.emailVerified,
    this.phoneNumberVerified,
    this.employee,
    this.client,
    this.admin,
    this.hr,
    this.marketing,
    this.role,
    this.active,
    this.isReferPerson,
    this.isMhEmployee,
    this.isHired,
    this.verified,
    this.noOfEmployee,
    this.employeeExperience,
    this.rating,
    this.totalWorkingHour,
    this.hourlyRate,
    this.certificates,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.cv,
    this.profilePicture,
  });

  final String? id;
  final String? name;
  final String? positionId;
  final String? positionName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? userIdNumber;
  final String? email;
  final String? phoneNumber;
  final String? presentAddress;
  final String? permanentAddress;
  final List<String>? languages;
  final String? higherEducation;
  final String? licensesNo;
  final String? emmergencyContact;
  final List<Skill>? skills;
  final String? countryName;
  final String? password;
  final String? plainPassword;
  final String? sourceId;
  final String? sourceName;
  final bool? emailVerified;
  final bool? phoneNumberVerified;
  final bool? employee;
  final bool? client;
  final bool? admin;
  final bool? hr;
  final bool? marketing;
  final String? role;
  final bool? active;
  final bool? isReferPerson;
  final bool? isMhEmployee;
  final bool? isHired;
  final bool? verified;
  final int? noOfEmployee;
  final int? employeeExperience;
  final int? rating;
  final int? totalWorkingHour;
  final int? hourlyRate;
  final List<dynamic>? certificates;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? cv;
  final String? profilePicture;

  factory Employee.fromRawJson(String str) => Employee.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json["_id"],
    name: json["name"],
    positionId: json["positionId"],
    positionName: json["positionName"],
    gender: json["gender"],
    dateOfBirth: json["dateOfBirth"] == null ? null : DateTime.parse(json["dateOfBirth"]),
    userIdNumber: json["userIdNumber"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    presentAddress: json["presentAddress"],
    permanentAddress: json["permanentAddress"],
    languages: json["languages"] == null ? [] : List<String>.from(json["languages"]!.map((x) => x)),
    higherEducation: json["higherEducation"],
    licensesNo: json["licensesNo"],
    emmergencyContact: json["emmergencyContact"],
    skills: json["skills"] == null ? [] : List<Skill>.from(json["skills"]!.map((x) => Skill.fromJson(x))),
    countryName: json["countryName"],
    password: json["password"],
    plainPassword: json["plainPassword"],
    sourceId: json["sourceId"],
    sourceName: json["sourceName"],
    emailVerified: json["emailVerified"],
    phoneNumberVerified: json["phoneNumberVerified"],
    employee: json["employee"],
    client: json["client"],
    admin: json["admin"],
    hr: json["hr"],
    marketing: json["marketing"],
    role: json["role"],
    active: json["active"],
    isReferPerson: json["isReferPerson"],
    isMhEmployee: json["isMhEmployee"],
    isHired: json["isHired"],
    verified: json["verified"],
    noOfEmployee: json["noOfEmployee"],
    employeeExperience: json["employeeExperience"],
    rating: json["rating"],
    totalWorkingHour: json["totalWorkingHour"],
    hourlyRate: json["hourlyRate"],
    certificates: json["certificates"] == null ? [] : List<dynamic>.from(json["certificates"]!.map((x) => x)),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    cv: json["cv"],
    profilePicture: json["profilePicture"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "positionId": positionId,
    "positionName": positionName,
    "gender": gender,
    "dateOfBirth": dateOfBirth?.toIso8601String(),
    "userIdNumber": userIdNumber,
    "email": email,
    "phoneNumber": phoneNumber,
    "presentAddress": presentAddress,
    "permanentAddress": permanentAddress,
    "languages": languages == null ? [] : List<dynamic>.from(languages!.map((x) => x)),
    "higherEducation": higherEducation,
    "licensesNo": licensesNo,
    "emmergencyContact": emmergencyContact,
    "skills": skills == null ? [] : List<dynamic>.from(skills!.map((x) => x.toJson())),
    "countryName": countryName,
    "password": password,
    "plainPassword": plainPassword,
    "sourceId": sourceId,
    "sourceName": sourceName,
    "emailVerified": emailVerified,
    "phoneNumberVerified": phoneNumberVerified,
    "employee": employee,
    "client": client,
    "admin": admin,
    "hr": hr,
    "marketing": marketing,
    "role": role,
    "active": active,
    "isReferPerson": isReferPerson,
    "isMhEmployee": isMhEmployee,
    "isHired": isHired,
    "verified": verified,
    "noOfEmployee": noOfEmployee,
    "employeeExperience": employeeExperience,
    "rating": rating,
    "totalWorkingHour": totalWorkingHour,
    "hourlyRate": hourlyRate,
    "certificates": certificates == null ? [] : List<dynamic>.from(certificates!.map((x) => x)),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "cv": cv,
    "profilePicture": profilePicture,
  };
}

class Skill {
  Skill({
    this.skillId,
    this.skillName,
    this.id,
  });

  final String? skillId;
  final String? skillName;
  final String? id;

  factory Skill.fromRawJson(String str) => Skill.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
    skillId: json["skillId"],
    skillName: json["skillName"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "skillId": skillId,
    "skillName": skillName,
    "_id": id,
  };
}
