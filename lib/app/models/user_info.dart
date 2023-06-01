import 'push_notification_details.dart';

class UserInfo {
  String? status;
  int? statusCode;
  String? message;
  Details? details;

  UserInfo({this.status, this.statusCode, this.message, this.details});

  UserInfo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['statusCode'];
    message = json['message'];
    details =
    json['details'] != null ? new Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class Details {
  String? sId;
  String? firstName;
  String? lastName;
  String? name;
  String? positionId;
  String? positionName;
  String? userIdNumber;
  String? email;
  String? phoneNumber;
  String? bankName;
  String? accountNumber;
  String? routingNumber;
  String? dressSize;
  List<String>? languages;
  List<String>? certificates;
  String? countryName;
  bool? employee;
  bool? client;
  bool? admin;
  bool? hr;
  bool? marketing;
  String? role;
  bool? isReferPerson;
  bool? isMhEmployee;
  bool? isHired;
  String? hiredFromDate;
  String? hiredToDate;
  String? hiredBy;
  String? hiredByLat;
  String? hiredByLong;
  String? hiredByRestaurantName;
  String? hiredByRestaurantAddress;
  String? profilePicture;
  String? cv;
  bool? verified;
  bool? active;
  int? rating;
  int? totalWorkingHour;
  int? hourlyRate;
  int? clientDiscount;
  PushNotificationDetails? pushNotificationDetails;
  List<String>? skills;
  int? contractorHourlyRate;
  List<String>? menuPermission;

  Details(
      {this.sId,
        this.firstName,
        this.lastName,
        this.name,
        this.positionId,
        this.positionName,
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
        this.active,
        this.rating,
        this.totalWorkingHour,
        this.hourlyRate,
        this.clientDiscount,
        this.pushNotificationDetails,
        this.skills,
        this.contractorHourlyRate,
        this.menuPermission});

  Details.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    name = json['name'];
    positionId = json['positionId'];
    positionName = json['positionName'];
    userIdNumber = json['userIdNumber'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    bankName = json['bankName'];
    accountNumber = json['accountNumber'];
    routingNumber = json['routingNumber'];
    dressSize = json['dressSize'];
    if (json['languages'] != null) {
      languages = <String>[];
      json['languages'].forEach((v) {
        languages!.add(v);
      });
    }
    if (json['certificates'] != null) {
      certificates = <String>[];
      json['certificates'].forEach((v) {
        certificates!.add(v);
      });
    }
    countryName = json['countryName'];
    employee = json['employee'];
    client = json['client'];
    admin = json['admin'];
    hr = json['hr'];
    marketing = json['marketing'];
    role = json['role'];
    isReferPerson = json['isReferPerson'];
    isMhEmployee = json['isMhEmployee'];
    isHired = json['isHired'];
    hiredFromDate = json['hiredFromDate'];
    hiredToDate = json['hiredToDate'];
    hiredBy = json['hiredBy'];
    hiredByLat = json['hiredByLat'];
    hiredByLong = json['hiredByLong'];
    hiredByRestaurantName = json['hiredByRestaurantName'];
    hiredByRestaurantAddress = json['hiredByRestaurantAddress'];
    profilePicture = json['profilePicture'];
    cv = json['cv'];
    verified = json['verified'];
    active = json['active'];
    rating = json['rating'];
    totalWorkingHour = json['totalWorkingHour'];
    hourlyRate = json['hourlyRate'];
    clientDiscount = json['clientDiscount'];
    pushNotificationDetails = json['pushNotificationDetails'] != null
        ? PushNotificationDetails.fromJson(json['pushNotificationDetails'])
        : null;
    if (json['skills'] != null) {
      skills = <String>[];
      json['skills'].forEach((v) {
        skills!.add(v);
      });
    }
    contractorHourlyRate = json['contractorHourlyRate'];
    if (json['menuPermission'] != null) {
      menuPermission = <String>[];
      json['menuPermission'].forEach((v) {
        menuPermission!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['name'] = this.name;
    data['positionId'] = this.positionId;
    data['positionName'] = this.positionName;
    data['userIdNumber'] = this.userIdNumber;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['bankName'] = this.bankName;
    data['accountNumber'] = this.accountNumber;
    data['routingNumber'] = this.routingNumber;
    data['dressSize'] = this.dressSize;
    if (this.languages != null) {
      data['languages'] = this.languages!.map((v) => v).toList();
    }
    if (this.certificates != null) {
      data['certificates'] = this.certificates!.map((v) => v).toList();
    }
    data['countryName'] = this.countryName;
    data['employee'] = this.employee;
    data['client'] = this.client;
    data['admin'] = this.admin;
    data['hr'] = this.hr;
    data['marketing'] = this.marketing;
    data['role'] = this.role;
    data['isReferPerson'] = this.isReferPerson;
    data['isMhEmployee'] = this.isMhEmployee;
    data['isHired'] = this.isHired;
    data['hiredFromDate'] = this.hiredFromDate;
    data['hiredToDate'] = this.hiredToDate;
    data['hiredBy'] = this.hiredBy;
    data['hiredByLat'] = this.hiredByLat;
    data['hiredByLong'] = this.hiredByLong;
    data['hiredByRestaurantName'] = this.hiredByRestaurantName;
    data['hiredByRestaurantAddress'] = this.hiredByRestaurantAddress;
    data['profilePicture'] = this.profilePicture;
    data['cv'] = this.cv;
    data['verified'] = this.verified;
    data['active'] = this.active;
    data['rating'] = this.rating;
    data['totalWorkingHour'] = this.totalWorkingHour;
    data['hourlyRate'] = this.hourlyRate;
    data['clientDiscount'] = this.clientDiscount;
    if (this.pushNotificationDetails != null) {
      data['pushNotificationDetails'] = this.pushNotificationDetails!.toJson();
    }
    if (this.skills != null) {
      data['skills'] = this.skills!.map((v) => v).toList();
    }
    data['contractorHourlyRate'] = this.contractorHourlyRate;
    if (this.menuPermission != null) {
      data['menuPermission'] =
          this.menuPermission!.map((v) => v).toList();
    }
    return data;
  }
}