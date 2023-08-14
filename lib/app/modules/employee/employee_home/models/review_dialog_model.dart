class ReviewDialogModel {
  String? status;
  int? statusCode;
  List<ReviewDialogDetailsModel>? reviewDialogDetailsModel;

  ReviewDialogModel({this.status, this.statusCode, this.reviewDialogDetailsModel});

  ReviewDialogModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['statusCode'];
    if (json['details'] != null) {
      reviewDialogDetailsModel = <ReviewDialogDetailsModel>[];
      json['details'].forEach((v) {
        reviewDialogDetailsModel!.add(ReviewDialogDetailsModel.fromJson(v));
      });
    }
  }
}

class ReviewDialogDetailsModel {
  String? sId;
  String? employeeId;
  String? hiredBy;
  EmployeeDetails? employeeDetails;
  RestaurantDetails? restaurantDetails;

  ReviewDialogDetailsModel({this.sId, this.employeeId, this.hiredBy, this.employeeDetails, this.restaurantDetails});

  ReviewDialogDetailsModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    employeeId = json['employeeId'];
    hiredBy = json['hiredBy'];
    employeeDetails = json['employeeDetails'] != null ? EmployeeDetails.fromJson(json['employeeDetails']) : null;
    restaurantDetails =
        json['restaurantDetails'] != null ? RestaurantDetails.fromJson(json['restaurantDetails']) : null;
  }
}

class EmployeeDetails {
  String? name;
  String? profilePicture;
  String? sId;

  EmployeeDetails({this.name, this.profilePicture, this.sId});

  EmployeeDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profilePicture = json['profilePicture'];
    sId = json['_id'];
  }
}

class RestaurantDetails {
  String? hiredBy;
  String? restaurantName;
  String? sId;

  RestaurantDetails({this.hiredBy, this.restaurantName, this.sId});

  RestaurantDetails.fromJson(Map<String, dynamic> json) {
    hiredBy = json['hiredBy'];
    restaurantName = json['restaurantName'];
    sId = json['_id'];
  }
}
