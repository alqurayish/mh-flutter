import 'package:geolocator/geolocator.dart';
import 'package:mh/app/common/widgets/chat_with_user_choose.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../../../../common/controller/app_controller.dart';
import '../../../../common/controller/location_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_break_time.dart';
import '../../../../common/widgets/custom_dialog.dart';
import '../../../../common/widgets/custom_loader.dart';
import '../../../../enums/chat_with.dart';
import '../../../../models/check_in_out_histories.dart';
import '../../../../models/custom_error.dart';
import '../../../../models/employee_daily_statistics.dart';
import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';
import '../models/today_check_in_out_details.dart';

class EmployeeHomeController extends GetxController {

  BuildContext? context;

  final AppController appController = Get.find();
  final ApiHelper _apiHelper = Get.find();

  final GlobalKey<SlideActionState> key = GlobalKey();

  RxBool loading = false.obs;
  RxBool loadingCurrentLocation = false.obs;

  // done
  RxBool checkIn = false.obs;
  RxBool checkOut = false.obs;

  RxString locationFetchError = "".obs;

  RxString errorMsg = "".obs;

  RxBool showSlider = false.obs;

  Position? currentLocation;

  Rx<TodayCheckInOutDetails> todayCheckInOutDetails = TodayCheckInOutDetails().obs;

  @override
  void onInit() {
    _getTodayCheckInOutDetails();
    super.onInit();
  }


  @override
  void onDashboardClick() {
    Get.toNamed(Routes.employeeDashboard);
  }

  @override
  void onEmergencyCheckinCheckout() {
    Get.toNamed(Routes.employeeEmergencyCheckInOut);
  }

  @override
  void onHelpAndSupportClick() {
    // Get.toNamed(Routes.contactUs);
    // Get.toNamed(Routes.oneToOneChat);
    ChatWithUserChoose.show(context!);
  }

  @override
  void onNotificationClick() {
    Get.toNamed(Routes.clientNotification);
  }

  void chatWithAdmin() {
    Get.back(); // hide dialogue

    Get.toNamed(Routes.oneToOneChat, arguments: {
      MyStrings.arg.chatWith: ChatWith.admin,
    });
  }

  void chatWithRestaurant() {
    Get.back(); // hide dialogue

    Get.toNamed(Routes.oneToOneChat, arguments: {
      MyStrings.arg.chatWith: ChatWith.client,
    });
  }

  UserDailyStatistics get dailyStatistics => Utils.checkInOutToStatistics(
    CheckInCheckOutHistoryElement(
      employeeDetails: todayCheckInOutDetails.value.details?.employeeDetails,
      checkInCheckOutDetails: todayCheckInOutDetails.value.details?.checkInCheckOutDetails,
    )
  );

  void onCheckInCheckOut() {
    if(!checkIn.value && !checkOut.value) {
      _onCheckIn();
    } else {
      _onCheckout();
    }
  }

  Future<void> onBreakTimePickDone(int hour, int min) async {
    Map<String, dynamic> data = {
      "id": todayCheckInOutDetails.value.details!.id!,
      "employeeId": appController.user.value.userId,
      "checkOut": true,
      if(currentLocation?.latitude != null) "lat": currentLocation!.latitude.toString(),
      if(currentLocation?.longitude != null) "long": currentLocation?.longitude.toString(),
      "breakTime": (hour * 60) + (min * 5),
      "checkOutDistance": double.parse(getDistance.toStringAsFixed(2)),
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
      "employeeId": appController.user.value.userId,
      "checkIn": true,
      if(currentLocation?.latitude != null) "lat": currentLocation!.latitude.toString(),
      if(currentLocation?.longitude != null) "long": currentLocation?.longitude.toString(),
      "checkInDistance": double.parse(getDistance.toStringAsFixed(2)),
    };

    await _apiHelper.checkin(data).then((response) {
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
  }

  Future<void> _getTodayCheckInOutDetails() async {
    if(!(appController.user.value.employee?.isHired ?? false)) return;
    if(loading.value) return;

    loading.value = true;

    await _apiHelper.getTodayCheckInOutDetails(appController.user.value.userId).then((response) {

      loading.value = false;

      response.fold((CustomError customError) {

        Utils.errorDialog(context!, customError..onRetry = _getTodayCheckInOutDetails);

      }, (TodayCheckInOutDetails details) {

        todayCheckInOutDetails.value = details;

        Logcat.msg(details.toJson().toString(), printWithLog: true);

        // check in
        if(details.details == null || (!details.details!.checkInCheckOutDetails!.checkIn! && !details.details!.checkInCheckOutDetails!.emmergencyCheckIn!)) {
          checkIn.value = false;
          checkOut.value = false;

          _setCheckinOption();
        }
        // check out
        else if(!details.details!.checkInCheckOutDetails!.checkOut! && !details.details!.checkInCheckOutDetails!.emmergencyCheckOut!) {
          checkIn.value = true;

          _setCheckinOption();
        }
        else {
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

        if(getDistance > 200) {
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
    targetLat: double.parse(appController.user.value.employee!.hiredByLat!),
    targetLong: double.parse(appController.user.value.employee!.hiredByLong!),
    currentLat: currentLocation!.latitude,
    currentLong: currentLocation!.longitude,
  );

}
