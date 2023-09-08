import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mh/app/common/widgets/rating_review_widget.dart';
import 'package:mh/app/modules/employee/employee_home/models/common_response_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/employee_check_in_request_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/employee_check_out_request_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/review_dialog_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/review_request_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/single_notification_model_for_employee.dart';
import 'package:mh/app/modules/employee/employee_home/models/todays_work_schedule_model.dart';
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
import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';
import '../models/today_check_in_out_details.dart';

class EmployeeHomeController extends GetxController {
  final NotificationsController notificationsController = Get.find<NotificationsController>();
  BuildContext? context;

  final AppController appController = Get.find();
  final ApiHelper _apiHelper = Get.find();

  final GlobalKey<SlideActionWidgetState> key = GlobalKey();

  // done
  RxBool checkIn = false.obs;
  RxBool checkOut = false.obs;

  RxString locationFetchError = "".obs;
  Position? currentLocation;

  Rx<TodayCheckInOutDetails> todayCheckInOutDetails = TodayCheckInOutDetails().obs;
  RxBool todayCheckInCheckOutDetailsDataLoading = true.obs;

  // unread msg track
  RxInt unreadMsgFromClient = 0.obs;
  RxInt unreadMsgFromAdmin = 0.obs;

  RxList<NotificationModel> bookingHistoryList = <NotificationModel>[].obs;
  RxBool bookingHistoryDataLoaded = false.obs;

  RxDouble rating = 0.0.obs;
  TextEditingController tecReview = TextEditingController();

  Rx<TodayWorkScheduleModel> todayWorkSchedule = TodayWorkScheduleModel().obs;
  RxBool todayWorkScheduleDataLoading = true.obs;

  @override
  void onInit() async {
    await homeMethods();
    super.onInit();
  }

  @override
  void onReady() {
    Future.delayed(const Duration(seconds: 2), () => showReviewBottomSheet());
    super.onReady();
  }

  Future<void> homeMethods() async {
    notificationsController.getNotificationList;
    _trackUnreadMsg();
    await _getCurrentLocation();
    await _getTodayWorkSchedule();
    await _getTodayCheckInOutDetails();
    await getBookingHistory();
  }

  Future<void> _getCurrentLocation() async {
    Either<CustomError, Position> response = await LocationController.determinePosition();
    response.fold((l) {
      locationFetchError.value = l.msg;
    }, (Position position) {
      currentLocation = position;
    });
  }

  Future<void> _getTodayWorkSchedule() async {
    Either<CustomError, TodayWorkScheduleModel> responseData = await _apiHelper.getTodayWorkSchedule();
    todayWorkScheduleDataLoading.value = false;
    responseData.fold((CustomError customError) {
      Utils.errorDialog(context!, customError..onRetry = _getTodayWorkSchedule);
    }, (TodayWorkScheduleModel todayWorkScheduleInfo) {
      if (todayWorkScheduleInfo.status == 'success' && todayWorkScheduleInfo.todayWorkScheduleDetailsModel != null) {
        todayWorkSchedule.value = todayWorkScheduleInfo;
        todayWorkSchedule.refresh();
      }
    });
  }

  Future<void> getBookingHistory() async {
    Either<CustomError, SingleNotificationModelForEmployee> responseData =
        await _apiHelper.singleNotificationForEmployee();

    responseData.fold((CustomError customError) {
      Utils.errorDialog(context!, customError..onRetry = getBookingHistory);
    }, (SingleNotificationModelForEmployee response) {
      if (response.status == "success" && response.statusCode == 200 && response.details != null) {
        bookingHistoryList.value = response.details ?? [];
        bookingHistoryList.refresh();
      }
      bookingHistoryDataLoaded.value = true;
    });
  }

  Future<void> _getTodayCheckInOutDetails() async {
    Either<CustomError, TodayCheckInOutDetails> response =
        await _apiHelper.getTodayCheckInOutDetails(appController.user.value.employee?.id ?? '');
    todayCheckInCheckOutDetailsDataLoading.value = false;
    response.fold((CustomError customError) {
      Utils.errorDialog(context!, customError..onRetry = _getTodayCheckInOutDetails);
    }, (TodayCheckInOutDetails details) {
      Logcat.msg(details.toJson().toString(), printWithLog: true);
      if (details.status == 'success' && details.details != null) {
        todayCheckInOutDetails.value = details;
        checkOut.value = false;
        checkIn.value = true;
      } else if (details.status == 'success' && details.details == null) {
        checkIn.value = false;
        checkOut.value = false;
      }
    });
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

  Future<void> onCheckInCheckOut() async {
    if (!checkIn.value && !checkOut.value) {
      await _onCheckIn();
    } else {
      _onCheckout();
    }
  }

  Future<void> onBreakTimePickDone(int hour, int min) async {
    CustomLoader.show(context!);

    EmployeeCheckOutRequestModel employeeCheckOutRequestModel = EmployeeCheckOutRequestModel(
        id: todayCheckInOutDetails.value.details?.id ?? '',
        checkOut: true,
        lat: '${currentLocation?.latitude ?? 0.0}',
        long: '${currentLocation?.longitude ?? 0.0}',
        breakTime: (hour * 60) + (min * 5),
        totalWorkingHour:
            double.parse((double.parse(dailyStatistics.workingHour.split(' ').first) / 60).toStringAsFixed(2)),
        checkOutDistance: restaurantDistanceFromEmployee(
            targetLat:
                double.parse('${todayWorkSchedule.value.todayWorkScheduleDetailsModel?.restaurantDetails?.lat ?? 0.0}'),
            targetLng: double.parse(
                '${todayWorkSchedule.value.todayWorkScheduleDetailsModel?.restaurantDetails?.long ?? 0.0}')),
        checkOutTime: DateTime.now().toLocal().toString());

    Either<CustomError, Response> response =
        await _apiHelper.checkout(employeeCheckOutRequestModel: employeeCheckOutRequestModel);
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
  }

  Future<void> _onCheckIn() async {
    CustomLoader.show(context!);

    EmployeeCheckInRequestModel employeeCheckInRequestModel = EmployeeCheckInRequestModel(
        employeeId: appController.user.value.employee?.id ?? '',
        hiredBy: todayWorkSchedule.value.todayWorkScheduleDetailsModel?.restaurantDetails?.hiredBy ?? "",
        checkIn: true,
        lat: '${currentLocation?.latitude ?? 0.0}',
        long: '${currentLocation?.longitude ?? 0.0}',
        checkInDistance: restaurantDistanceFromEmployee(
            targetLat:
                double.parse('${todayWorkSchedule.value.todayWorkScheduleDetailsModel?.restaurantDetails?.lat ?? 0.0}'),
            targetLng: double.parse(
                '${todayWorkSchedule.value.todayWorkScheduleDetailsModel?.restaurantDetails?.long ?? 0.0}')),
        checkInTime: DateTime.now().toLocal().toString());

    Either<CustomError, CommonResponseModel> response =
        await _apiHelper.checkIn(employeeCheckInRequestModel: employeeCheckInRequestModel);
    CustomLoader.hide(context!);

    response.fold((CustomError customError) {
      CustomDialogue.information(
        context: context!,
        title: "Failed to CheckIn",
        description: customError.msg,
      );
    }, (CommonResponseModel clients) {
      refreshPage();
    });
  }

  void _onCheckout() {
    CustomBreakTime.show(context!, onBreakTimePickDone);
  }

  void resetSlider() {
    key.currentState?.reset();
  }

  void refreshPage() async {
    locationFetchError.value = "";
    todayWorkScheduleDataLoading.value = true;
    todayCheckInCheckOutDetailsDataLoading.value = true;
    checkIn.value = false;
    checkOut.value = false;
    bookingHistoryDataLoaded.value = false;

    await homeMethods();
    Utils.showSnackBar(message: 'This page has been refreshed', isTrue: true);
  }

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

  void updateNotification({required String id, required String hiredStatus}) {
    CustomLoader.show(context!);

    NotificationUpdateRequestModel notificationUpdateRequestModel =
        NotificationUpdateRequestModel(id: id, fromWhere: 'employee_home_view', hiredStatus: hiredStatus);
    _apiHelper
        .updateNotification(notificationUpdateRequestModel: notificationUpdateRequestModel)
        .then((Either<CustomError, NotificationUpdateResponseModel> response) {
      CustomLoader.hide(context!);
      Get.back();
      Get.back();
      response.fold((CustomError customError) {
        Utils.errorDialog(context!, customError);
      }, (NotificationUpdateResponseModel responseModel) {
        if (responseModel.status == 'success' && responseModel.statusCode == 200) {
          getBookingHistory();
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
              reviewFor: 'client',
              onCancelClick: onCancelClick,
              onRatingUpdate: onRatingUpdate,
              onReviewSubmit: onReviewSubmitClick,
              reviewDialogDetailsModel: response.reviewDialogDetailsModel!.first,
              tecReview: tecReview));
        }
      });
    });
  }

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

  void onCalenderClick() {
    Get.toNamed(Routes.calender, arguments: [appController.user.value.employee?.id ?? 0, '']);
  }

  void onBookedHistoryClick() {
    Get.toNamed(Routes.employeeBookedHistory);
  }

  void onHiredHistoryClick() {}

  double restaurantDistanceFromEmployee({required double targetLat, required double targetLng}) {
    if (currentLocation != null) {
      return LocationController.calculateDistance(
          targetLat: targetLat,
          targetLong: targetLng,
          currentLat: //currentLocation!.latitude,
              23.76856796911088,
          currentLong: //currentLocation!.longitude
              90.35680051892997);
    }
    return 0.0;
  }

  bool get showCheckInCheckOutWidget {
    return todayWorkScheduleDataLoading.value == false &&
        todayWorkSchedule.value.todayWorkScheduleDetailsModel != null &&
        restaurantDistanceFromEmployee(
                targetLat: double.parse(
                    todayWorkSchedule.value.todayWorkScheduleDetailsModel?.restaurantDetails?.lat ?? '0.0'),
                targetLng: double.parse(
                    todayWorkSchedule.value.todayWorkScheduleDetailsModel?.restaurantDetails?.long ?? '0.0')) <
            200 &&
        todayCheckInCheckOutDetailsDataLoading.value == false &&
        (checkIn.value == false || checkOut.value == false);
  }
}
