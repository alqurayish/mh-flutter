class AddToShortListRequestModel {
  final String employeeId;
  final List<RequestDate> requestDate;

  AddToShortListRequestModel({required this.employeeId, required this.requestDate});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employeeId'] = employeeId;
    data['requestDate'] = requestDate.map((v) => v.toJson()).toList();
    return data;
  }
}

class RequestDate {
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;

  RequestDate({ this.startDate,  this.endDate,  this.startTime,  this.endTime});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    return data;
  }
}
