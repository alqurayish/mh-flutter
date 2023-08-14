import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mh/app/common/style/my_decoration.dart';
import 'package:mh/app/common/widgets/custom_network_image.dart';
import 'package:mh/app/common/widgets/rating_review_widget.dart';
import 'package:mh/app/modules/employee/employee_home/models/common_response_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/review_dialog_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/review_request_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/single_notification_model_for_employee.dart';
import 'package:mh/app/modules/employee/employee_home/widgets/slide_action_widget.dart';
import 'package:mh/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:mh/app/modules/notifications/models/notification_response_model.dart';
import 'package:mh/app/modules/notifications/models/notification_update_request_model.dart';
import 'package:mh/app/modules/notifications/models/notification_update_response_model.dart';
import '../../../../common/controller/app_controller.dart';
import '../../../../common/controller/location_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/chat_with_user_choose.dart';
import '../../../../common/widgets/custom_break_time.dart';
import '../../../../common/widgets/custom_dialog.dart';
import '../../../../common/widgets/custom_loader.dart';
import '../../../../models/check_in_out_histories.dart';
import '../../../../models/custom_error.dart';
import '../../../../models/employee_daily_statistics.dart';
import '../../../../models/user_info.dart';
import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';
import '../models/today_check_in_out_details.dart';

class EmployeeHomeController extends GetxController {
  final NotificationsController notificationsController = Get.find<NotificationsController>();
  BuildContext? context;

  final AppController appController = Get.find();
  final ApiHelper _apiHelper = Get.find();

  final GlobalKey<SlideActionWidgetState> key = GlobalKey();

  RxBool loading = false.obs;
  RxBool loadingCurrentLocation = false.obs;
  RxBool currentLocationDataLoaded = false.obs;

  // done
  RxBool checkIn = false.obs;
  RxBool checkOut = false.obs;

  RxString locationFetchError = "".obs;

  RxString errorMsg = "".obs;

  RxBool showSlider = false.obs;

  Position? currentLocation;

  Rx<TodayCheckInOutDetails> todayCheckInOutDetails = TodayCheckInOutDetails().obs;

  // unread msg track
  RxInt unreadMsgFromClient = 0.obs;
  RxInt unreadMsgFromAdmin = 0.obs;

  Rx<NotificationModel> singleNotification = NotificationModel().obs;
  RxBool singleNotificationDataLoading = false.obs;
  RxBool showNormalText = false.obs;

  RxDouble rating = 0.0.obs;
  TextEditingController tecReview = TextEditingController();

  @override
  void onInit() {
    homeMethods();
    super.onInit();
  }

  @override
  void onReady() {
    Future.delayed(const Duration(seconds: 3), () => showReviewBottomSheet());
    super.onReady();
  }

  void homeMethods() {
    _getSingleNotification();
    _trackUnreadMsg();
    _getTodayCheckInOutDetails();
    notificationsController.getNotificationList();
  }

  void onDashboardClick() {
    Get.toNamed(Routes.employeeDashboard);
  }

  void onEmergencyCheckInCheckout() {
    Get.toNamed(Routes.employeeEmergencyCheckInOut);
  }

  void onHelpAndSupportClick() {
    ChatWithUserChoose.show(
      context!,
      msgFromAdmin: unreadMsgFromAdmin.value,
      msgFromClient: unreadMsgFromClient.value,
    );
  }

  void onNotificationClick() {
    Get.toNamed(Routes.clientNotification);
  }

  void onProfileClick() {
    Get.toNamed(Routes.employeeSelfProfile);
  }

  void chatWithAdmin() {
    Get.back(); // hide dialogue

    Get.toNamed(Routes.supportChat, arguments: {
      MyStrings.arg.fromId: appController.user.value.userId,
      MyStrings.arg.toId: "allAdmin",
      MyStrings.arg.supportChatDocId: appController.user.value.userId,
      MyStrings.arg.receiverName: "Support",
    });
  }

  void chatWithClient() {
    Get.back(); // hide dialogue

    Get.toNamed(Routes.clientEmployeeChat, arguments: {
      MyStrings.arg.receiverName: appController.user.value.employee?.hiredByRestaurantName ?? "-",
      MyStrings.arg.fromId: appController.user.value.userId,
      MyStrings.arg.toId: appController.user.value.employee?.hiredBy ?? "",
      MyStrings.arg.clientId: appController.user.value.employee?.hiredBy ?? "",
      MyStrings.arg.employeeId: appController.user.value.userId,
    });
  }

  UserDailyStatistics get dailyStatistics => Utils.checkInOutToStatistics(CheckInCheckOutHistoryElement(
        employeeDetails: todayCheckInOutDetails.value.details?.employeeDetails,
        checkInCheckOutDetails: todayCheckInOutDetails.value.details?.checkInCheckOutDetails,
      ));

  bool get isTodayInBetweenFromDateAndToDate {
    DateTime today = DateTime.parse(DateTime.now().toString().split(" ").first);

    if (appController.user.value.employee?.hiredFromDate != null &&
        appController.user.value.employee?.hiredToDate != null) {
      DateTime fromDate = DateTime.parse(appController.user.value.employee!.hiredFromDate.toString().split(" ").first);
      DateTime toDate = DateTime.parse(appController.user.value.employee!.hiredToDate.toString().split(" ").first);

      return (today.isAtSameMomentAs(fromDate) || today.isAfter(fromDate)) &&
          (today.isAtSameMomentAs(toDate) || today.isBefore(toDate));
    }

    return false;
  }

  void onCheckInCheckOut() {
    if (!checkIn.value && !checkOut.value) {
      _onCheckIn();
    } else {
      _onCheckout();
    }
  }

  Future<void> onBreakTimePickDone(int hour, int min) async {
    Map<String, dynamic> data = {
      "checkOutTime": DateTime.now().toLocal().toString(),
      "id": todayCheckInOutDetails.value.details!.id!,
      "employeeId": appController.user.value.userId,
      "checkOut": true,
      if (currentLocation?.latitude != null) "lat": currentLocation!.latitude.toString(),
      if (currentLocation?.longitude != null) "long": currentLocation?.longitude.toString(),
      "breakTime": (hour * 60) + (min * 5),
      "checkOutDistance": double.parse(getDistance.toStringAsFixed(2)),
      "totalWorkingHour":
          double.parse((double.parse(dailyStatistics.workingHour.split(' ').first) / 60).toStringAsFixed(2))
    };

    CustomLoader.show(context!);

    await _apiHelper.checkout(data).then((response) {
      CustomLoader.hide(context!);
      response.fold((CustomError customError) {
        CustomDialogue.information(
          context: context!,
          title: "Failed to Checkout",
          description: customError.msg,
        );
      }, (Response checkoutResponse) {
        refreshPage();
      });
    });
  }

  Future<void> _onCheckIn() async {
    Map<String, dynamic> data = {
      "checkInTime": DateTime.now().toLocal().toString(),
      "employeeId": appController.user.value.userId,
      "checkIn": true,
      if (currentLocation?.latitude != null) "lat": currentLocation!.latitude.toString(),
      if (currentLocation?.longitude != null) "long": currentLocation?.longitude.toString(),
      "checkInDistance": double.parse(getDistance.toStringAsFixed(2)),
    };

    await _apiHelper.checkIn(data).then((response) {
      response.fold((CustomError customError) {
        CustomDialogue.information(
          context: context!,
          title: "Failed to CheckIn",
          description: customError.msg,
        );
      }, (TodayCheckInOutDetails clients) {
        refreshPage();
      });
    });
  }

  void _onCheckout() {
    CustomBreakTime.show(context!, onBreakTimePickDone);
  }

  void resetSlider() {
    key.currentState?.reset();
  }

  Future<void> refreshPage() async {
    checkIn.value = false;
    checkOut.value = false;

    loading.value = false;

    locationFetchError = "".obs;

    showSlider.value = false;

    _getTodayCheckInOutDetails();
    _getSingleNotification();
    _trackUnreadMsg();
    notificationsController.getNotificationList;
  }

  Future<void> _getTodayCheckInOutDetails() async {
    await _apiHelper.clientDetails(appController.user.value.userId).then((response) {
      response.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _getTodayCheckInOutDetails);
      }, (UserInfo userInfo) {
        appController.user.value.employee = appController.user.value.employee?.copyWith(userInfo);
        appController.user.refresh();
      });
    });

    if (!(appController.user.value.employee?.isHired ?? false)) return;
    if (loading.value) return;

    loading.value = true;

    await _apiHelper.getTodayCheckInOutDetails(appController.user.value.userId).then((response) {
      loading.value = false;

      response.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _getTodayCheckInOutDetails);
      }, (TodayCheckInOutDetails details) {
        todayCheckInOutDetails.value = details;
        Logcat.msg(details.toJson().toString(), printWithLog: true);

        // check in
        if (details.details == null ||
            (!details.details!.checkInCheckOutDetails!.checkIn! &&
                !details.details!.checkInCheckOutDetails!.emmergencyCheckIn!)) {
          checkIn.value = false;
          checkOut.value = false;

          _setCheckinOption();
        }
        // check out
        else if (!details.details!.checkInCheckOutDetails!.checkOut! &&
            !details.details!.checkInCheckOutDetails!.emmergencyCheckOut!) {
          checkIn.value = true;

          _setCheckinOption();
        } else {
          checkIn.value = true;
          checkOut.value = true;
        }
      });
    });
  }

  // normal or emergency
  Future<void> _setCheckinOption() async {
    loadingCurrentLocation.value = true;

    await LocationController.determinePosition().then((value) {
      loadingCurrentLocation.value = false;

      value.fold((l) {
        locationFetchError.value = l.msg;
        showSlider.value = false;
      }, (Position position) {
        currentLocation = position;
        currentLocationDataLoaded.value = true;

        if (getDistance > 200) {
          showSlider.value = false;
          errorMsg.value = "You are ${getDistance.toStringAsFixed(2)}m away from restaurant";
        } else {
          showSlider.value = true;
          errorMsg.value = "";
        }
      });
    });
  }

  double get getDistance => LocationController.calculateDistance(
      targetLat: double.parse(singleNotification.value.hiredByLat ?? ''),
      targetLong: double.parse(singleNotification.value.hiredByLong ?? ''),
      currentLat: currentLocation!.latitude,
      //23.79714497663383,
      currentLong: currentLocation!.longitude
      //90.42769130319357
      );

  void _trackUnreadMsg() {
    if (appController.user.value.employee?.isHired ?? false) {
      FirebaseFirestore.instance
          .collection('employee_client_chat')
          .where("employeeId", isEqualTo: appController.user.value.userId)
          .where("clientId", isEqualTo: appController.user.value.employee!.hiredBy!)
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> event) {
        if (event.docs.isNotEmpty) {
          Map<String, dynamic> data = event.docs.first.data();

          unreadMsgFromClient.value = data["${appController.user.value.userId}_unread"];
        }
      });
    }

    FirebaseFirestore.instance
        .collection('support_chat')
        .doc(appController.user.value.userId)
        .snapshots()
        .listen((event) {
      if (event.exists) {
        Map<String, dynamic> data = event.data()!;
        unreadMsgFromAdmin.value = data["${appController.user.value.userId}_unread"];
      }
    });
  }

  void onHiredYouTap() {
    if (singleNotification.value.hiredStatus == null || singleNotification.value.hiredStatus == "REQUESTED") {
      Get.bottomSheet(Container(
        color: MyColors.lightCard(context!),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                _updateNotification(id: singleNotification.value.id ?? '', hiredStatus: 'ALLOW');
              },
              leading: const Icon(CupertinoIcons.check_mark, color: Colors.grey),
              title: Text('Allow', style: MyColors.l111111_dtext(context!).regular16_5),
            ),
            const Divider(
              height: 1,
            ),
            ListTile(
              onTap: () {
                _updateNotification(id: singleNotification.value.id ?? '', hiredStatus: 'DENY');
              },
              leading: const Icon(CupertinoIcons.clear, color: Colors.grey),
              title: Text('Deny', style: MyColors.l111111_dtext(context!).regular16_5),
            ),
            const Divider(
              height: 1,
            ),
            ListTile(
              onTap: () {
                Get.back();
              },
              leading: const Icon(
                Icons.remove,
                color: Colors.red,
              ),
              title: Text('Cancel', style: MyColors.l111111_dtext(context!).semiBold15.copyWith(color: Colors.red)),
            ),
            const Divider(
              height: 1,
            ),
          ],
        ),
      ));
    }
  }

  void _getSingleNotification() {
    singleNotificationDataLoading.value = true;
    _apiHelper
        .singleNotificationForEmployee()
        .then((Either<CustomError, SingleNotificationModelForEmployee> responseData) {
      singleNotificationDataLoading.value = false;
      responseData.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _getSingleNotification);
      }, (SingleNotificationModelForEmployee response) {
        if (response.status == "success" && response.statusCode == 200 && response.details != null) {
          singleNotification.value = response.details!;
          singleNotification.refresh();
        } else {
          showNormalText.value = true;
        }
      });
    });
  }

  void _updateNotification({required String id, required String hiredStatus}) {
    Get.back();
    CustomLoader.show(context!);

    NotificationUpdateRequestModel notificationUpdateRequestModel =
        NotificationUpdateRequestModel(id: id, fromWhere: 'employee_home_view', hiredStatus: hiredStatus);
    _apiHelper
        .updateNotification(notificationUpdateRequestModel: notificationUpdateRequestModel)
        .then((Either<CustomError, NotificationUpdateResponseModel> response) {
      CustomLoader.hide(context!);
      response.fold((CustomError customError) {
        Utils.errorDialog(context!, customError);
      }, (NotificationUpdateResponseModel responseModel) {
        if (responseModel.status == 'success' && responseModel.statusCode == 200) {
          _getSingleNotification();
          _getTodayCheckInOutDetails();
        }
      });
    });
  }

  void onPaymentHistoryClick() {
    Get.toNamed(Routes.employeePaymentHistory);
  }

  void showReviewBottomSheet() {
    _apiHelper.showReviewDialog().then((Either<CustomError, ReviewDialogModel> responseData) {
      responseData.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry);
      }, (ReviewDialogModel response) {
        if (response.status == "success" &&
            response.statusCode == 200 &&
            response.reviewDialogDetailsModel != null &&
            response.reviewDialogDetailsModel!.isNotEmpty) {
          Get.bottomSheet(RatingReviewWidget(
                  onCancelClick: onCancelClick,
                  onRatingUpdate: onRatingUpdate,
                  onReviewSubmit: onReviewSubmitClick,
                  reviewDialogDetailsModel: response.reviewDialogDetailsModel!.first,
                  tecReview: tecReview)
              //reviewDialogWidget(reviewDialogDetails: response.reviewDialogDetailsModel!.first)
              );
        }
      });
    });
  }

/*  Widget reviewDialogWidget({required ReviewDialogDetailsModel reviewDialogDetails}) {
    return Stack(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                color: Colors.white),
            height: 380,
            child: Center(
                child: Column(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CustomNetworkImage(
                    radius: 5,
                    url: reviewDialogDetails.restaurantDetails?.profileImage ??
                        'https://logowik.com/content/uploads/images/restaurant9491.logowik.com.webp',
                  ),
                ),
                const SizedBox(height: 10),
                Text('${reviewDialogDetails.restaurantDetails?.restaurantName}',
                    style: MyColors.l111111_dwhite(context!).semiBold16),
                const SizedBox(height: 20),
                RatingBar.builder(
                  initialRating: 0.0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (double rat) {
                    rating.value = rat;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: tecReview,
                  keyboardType: TextInputType.multiline,
                  minLines: 2,
                  maxLines: null,
                  cursorColor: MyColors.c_C6A34F,
                  style: MyColors.l111111_dwhite(context!).regular14,
                  decoration: MyDecoration.inputFieldDecoration(
                    context: context!,
                    label: "Comment if any (optional)",
                  ),
                ),
                const SizedBox(height: 30),
                CustomButtons.button(
                  height: 48,
                  margin: EdgeInsets.zero,
                  onTap: () => onReviewSubmitClick(
                      id: reviewDialogDetails.id ?? '',
                      reviewForId: reviewDialogDetails.restaurantDetails?.hiredBy ?? ''),
                  text: "Submit",
                  customButtonStyle: CustomButtonStyle.radiusTopBottomCorner,
                ),
              ],
            ))),
        Positioned.fill(
            child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              onTap: () => onReviewSubmitClick(
                  manualRating: 5.0,
                  id: reviewDialogDetails.id ?? '',
                  reviewForId: reviewDialogDetails.restaurantDetails?.hiredBy ?? ''),
              child: const CircleAvatar(
                radius: 15.0,
                backgroundColor: Colors.red,
                child: Icon(Icons.clear, color: Colors.white, size: 20),
              ),
            ),
          ),
        ))
      ],
    );
  }*/

  void onReviewSubmitClick({required String id, required String reviewForId}) {
    Get.back();

    CustomLoader.show(context!);

    ReviewRequestModel reviewRequestModel =
        ReviewRequestModel(rating: rating.value, reviewForId: reviewForId, comment: tecReview.text, hiredId: id);

    _apiHelper
        .giveReview(reviewRequestModel: reviewRequestModel)
        .then((Either<CustomError, CommonResponseModel> responseData) {
      CustomLoader.hide(context!);
      responseData.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry);
      }, (CommonResponseModel response) {
        if (response.status == "success" && response.statusCode == 201) {
          tecReview.clear();
          Get.rawSnackbar(
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(10.0),
              title: 'Success',
              message: 'Thanks for your review...',
              backgroundColor: Colors.green.shade600,
              borderRadius: 10.0);
        }
      });
    });
  }

  void onCancelClick({required String id, required String reviewForId, required double manualRating}) {
    Get.back();

    CustomLoader.show(context!);

    ReviewRequestModel reviewRequestModel =
        ReviewRequestModel(rating: manualRating, reviewForId: reviewForId, comment: tecReview.text, hiredId: id);

    _apiHelper
        .giveReview(reviewRequestModel: reviewRequestModel)
        .then((Either<CustomError, CommonResponseModel> responseData) {
      CustomLoader.hide(context!);
      responseData.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry);
      }, (CommonResponseModel response) {
        if (response.status == "success" && response.statusCode == 201) {
          tecReview.clear();
        }
      });
    });
  }

  void onRatingUpdate(double rat) {
    rating.value = rat;
  }
}
