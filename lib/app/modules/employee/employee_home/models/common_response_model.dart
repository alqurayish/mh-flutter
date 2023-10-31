class CommonResponseModel {
  String? status;
  int? statusCode;

  CommonResponseModel({this.status, this.statusCode});

  CommonResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['statusCode'];
  }
}
