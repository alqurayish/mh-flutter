import '../../../../models/employee_details.dart';

class ShortlistedEmployees {
  String? status;
  int? statusCode;
  String? message;
  int? total;
  int? count;
  int? next;
  List<ShortList>? shortList;

  ShortlistedEmployees({
    this.status,
    this.statusCode,
    this.message,
    this.total,
    this.count,
    this.next,
    this.shortList,
  });

  ShortlistedEmployees.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['statusCode'];
    message = json['message'];
    total = json['total'];
    count = json['count'];
    next = json['next'];
    if (json['shortList'] != null) {
      shortList = <ShortList>[];
      json['shortList'].forEach((v) {
        shortList!.add(ShortList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['total'] = total;
    data['count'] = count;
    data['next'] = next;
    if (shortList != null) {
      data['shortList'] = shortList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShortList {
  String? sId;
  String? employeeId;
  EmployeeDetails? employeeDetails;
  int? feeAmount;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? iV;
  DateTime? fromDate;
  DateTime? toDate;

  ShortList({
    this.sId,
    this.employeeId,
    this.employeeDetails,
    this.feeAmount,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.fromDate,
    this.toDate,
  });

  ShortList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    employeeId = json['employeeId'];
    employeeDetails = json['employeeDetails'] != null
        ? EmployeeDetails.fromJson(json['employeeDetails'])
        : null;
    feeAmount = json['feeAmount'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'] == null ? null : DateTime.parse(json["createdAt"]);
    updatedAt = json['updatedAt'] == null ? null : DateTime.parse(json["updatedAt"]);
    iV = json['__v'];
    fromDate = json['fromDate'] == null ? null : DateTime.parse(json["fromDate"]);
    toDate = json['toDate'] == null ? null : DateTime.parse(json["toDate"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['employeeId'] = employeeId;
    if (employeeDetails != null) {
      data['employeeDetails'] = employeeDetails!.toJson();
    }
    data['feeAmount'] = feeAmount;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    return data;
  }
}
