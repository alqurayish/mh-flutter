class StripeResponseModel {
  String? status;
  int? statusCode;
  String? message;
  Details? details;

  StripeResponseModel(
      {this.status, this.statusCode, this.message, this.details});

  StripeResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['statusCode'];
    message = json['message'];
    details =
    json['details'] != null ? Details.fromJson(json['details']) : null;
  }
}

class Details {
  String? id;
  String? url;

  Details({this.id, this.url});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }
}
