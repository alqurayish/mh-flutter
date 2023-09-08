class TodayWorkScheduleModel {
  String? status;
  int? statusCode;
  String? message;
  TodayWorkScheduleDetailsModel? todayWorkScheduleDetailsModel;

  TodayWorkScheduleModel(
      {this.status, this.statusCode, this.message, this.todayWorkScheduleDetailsModel});

  TodayWorkScheduleModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['statusCode'];
    message = json['message'];
    todayWorkScheduleDetailsModel =
    json['result'] != null ? TodayWorkScheduleDetailsModel.fromJson(json['result']) : null;
  }

}

class TodayWorkScheduleDetailsModel {
  RestaurantDetails? restaurantDetails;
  String? startTime;
  String? endTime;

  TodayWorkScheduleDetailsModel({this.restaurantDetails, this.startTime, this.endTime});

  TodayWorkScheduleDetailsModel.fromJson(Map<String, dynamic> json) {
    restaurantDetails = json['restaurantDetails'] != null
        ? RestaurantDetails.fromJson(json['restaurantDetails'])
        : null;
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

}

class RestaurantDetails {
  String? hiredBy;
  String? restaurantName;
  String? restaurantAddress;
  String? lat;
  String? long;
  String? sId;

  RestaurantDetails(
      {this.hiredBy,
        this.restaurantName,
        this.restaurantAddress,
        this.lat,
        this.long,
        this.sId});

  RestaurantDetails.fromJson(Map<String, dynamic> json) {
    hiredBy = json['hiredBy'];
    restaurantName = json['restaurantName'];
    restaurantAddress = json['restaurantAddress'];
    lat = json['lat'];
    long = json['long'];
    sId = json['_id'];
  }

}
