class AddToShortListRequestModel {
  final String employeeId;
  final List<RequestDateModel> requestDateList;

  AddToShortListRequestModel({required this.employeeId, required this.requestDateList});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employeeId'] = employeeId;
    data['requestDate'] = requestDateList.map((v) => v.toJson()).toList();
    return data;
  }
}

class RequestDateModel {
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;

  RequestDateModel({this.startDate, this.endDate, this.startTime, this.endTime});

  RequestDateModel.fromJson(Map<String, dynamic> json) {
    startDate = json['startDate'];
    endDate = json['endDate'];
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    return data;
  }
}
