import 'dart:convert';

class RequestedEmployees {
  RequestedEmployees({
    this.status,
    this.statusCode,
    this.message,
    this.total,
    this.count,
    this.next,
    this.requestEmployees,
  });

  final String? status;
  final int? statusCode;
  final String? message;
  final int? total;
  final int? count;
  final int? next;
  final List<RequestEmployee>? requestEmployees;

  factory RequestedEmployees.fromRawJson(String str) => RequestedEmployees.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequestedEmployees.fromJson(Map<String, dynamic> json) => RequestedEmployees(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    total: json["total"],
    count: json["count"],
    next: json["next"],
    requestEmployees: json["requestEmployees"] == null ? [] : List<RequestEmployee>.from(json["requestEmployees"]!.map((x) => RequestEmployee.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "total": total,
    "count": count,
    "next": next,
    "requestEmployees": requestEmployees == null ? [] : List<dynamic>.from(requestEmployees!.map((x) => x.toJson())),
  };
}

class RequestEmployee {
  RequestEmployee({
    this.id,
    this.requestClientId,
    this.clientDetails,
    this.clientRequestDetails,
    this.active,
    this.createdBy,
    this.suggestedEmployeeDetails,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? id;
  final String? requestClientId;
  final ClientDetails? clientDetails;
  final List<ClientRequestDetail>? clientRequestDetails;
  final bool? active;
  final String? createdBy;
  final List<SuggestedEmployeeDetail>? suggestedEmployeeDetails;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory RequestEmployee.fromRawJson(String str) => RequestEmployee.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequestEmployee.fromJson(Map<String, dynamic> json) => RequestEmployee(
    id: json["_id"],
    requestClientId: json["requestClientId"],
    clientDetails: json["clientDetails"] == null ? null : ClientDetails.fromJson(json["clientDetails"]),
    clientRequestDetails: json["clientRequestDetails"] == null ? [] : List<ClientRequestDetail>.from(json["clientRequestDetails"]!.map((x) => ClientRequestDetail.fromJson(x))),
    active: json["active"],
    createdBy: json["createdBy"],
    suggestedEmployeeDetails: json["suggestedEmployeeDetails"] == null ? [] : List<SuggestedEmployeeDetail>.from(json["suggestedEmployeeDetails"]!.map((x) => SuggestedEmployeeDetail.fromJson(x))),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "requestClientId": requestClientId,
    "clientDetails": clientDetails?.toJson(),
    "clientRequestDetails": clientRequestDetails == null ? [] : List<dynamic>.from(clientRequestDetails!.map((x) => x.toJson())),
    "active": active,
    "createdBy": createdBy,
    "suggestedEmployeeDetails": suggestedEmployeeDetails == null ? [] : List<dynamic>.from(suggestedEmployeeDetails!.map((x) => x.toJson())),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class ClientDetails {
  ClientDetails({
    this.requestClientId,
    this.restaurantName,
    this.restaurantAddress,
    this.email,
    this.phoneNumber,
    this.lat,
    this.long,
    this.id,
  });

  final String? requestClientId;
  final String? restaurantName;
  final String? restaurantAddress;
  final String? email;
  final String? phoneNumber;
  final String? lat;
  final String? long;
  final String? id;

  factory ClientDetails.fromRawJson(String str) => ClientDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClientDetails.fromJson(Map<String, dynamic> json) => ClientDetails(
    requestClientId: json["requestClientId"],
    restaurantName: json["restaurantName"],
    restaurantAddress: json["restaurantAddress"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    lat: json["lat"],
    long: json["long"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "requestClientId": requestClientId,
    "restaurantName": restaurantName,
    "restaurantAddress": restaurantAddress,
    "email": email,
    "phoneNumber": phoneNumber,
    "lat": lat,
    "long": long,
    "_id": id,
  };
}

class ClientRequestDetail {
  ClientRequestDetail({
    this.positionId,
    this.positionName,
    this.numOfEmployee,
    this.id,
  });

  final String? positionId;
  final String? positionName;
  int? numOfEmployee;
  final String? id;

  factory ClientRequestDetail.fromRawJson(String str) => ClientRequestDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClientRequestDetail.fromJson(Map<String, dynamic> json) => ClientRequestDetail(
    positionId: json["positionId"],
    positionName: json["positionName"],
    numOfEmployee: json["numOfEmployee"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "positionId": positionId,
    "positionName": positionName,
    "numOfEmployee": numOfEmployee,
    "_id": id,
  };
}

class SuggestedEmployeeDetail {
  SuggestedEmployeeDetail({
    this.employeeId,
    this.name,
    this.positionId,
    this.positionName,
    this.rating,
    this.totalWorkingHour,
    this.hourlyRate,
    this.profilePicture,
    this.cv,
    this.id,
  });

  final String? employeeId;
  final String? name;
  final String? positionId;
  final String? positionName;
  final int? rating;
  final int? totalWorkingHour;
  final double? hourlyRate;
  final String? profilePicture;
  final String? cv;
  final String? id;

  factory SuggestedEmployeeDetail.fromRawJson(String str) => SuggestedEmployeeDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SuggestedEmployeeDetail.fromJson(Map<String, dynamic> json) => SuggestedEmployeeDetail(
    employeeId: json["employeeId"],
    name: json["name"],
    positionId: json["positionId"],
    positionName: json["positionName"],
    rating: json["rating"],
    totalWorkingHour: json["totalWorkingHour"],
    hourlyRate: double.parse(json["hourlyRate"].toString()),
    profilePicture: json["profilePicture"],
    cv: json["cv"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "employeeId": employeeId,
    "name": name,
    "positionId": positionId,
    "positionName": positionName,
    "rating": rating,
    "totalWorkingHour": totalWorkingHour,
    "hourlyRate": hourlyRate,
    "profilePicture": profilePicture,
    "cv": cv,
    "_id": id,
  };
}
