import 'package:geolocator/geolocator.dart';
import 'package:mh/app/common/widgets/custom_loader.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../../../../common/controller/app_controller.dart';
import '../../../../common/controller/location_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_break_time.dart';
import '../../../../common/widgets/custom_dialog.dart';
import '../../../../models/custom_error.dart';
import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';
import '../../employee_emergency_check_in_out/today_check_in_out_details.dart';

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
    Get.toNamed(Routes.contactUs);
  }

  @override
  void onNotificationClick() {
    Get.toNamed(Routes.clientNotification);
  }

  String get getCheckInTime {
    if(todayCheckInOutDetails.value.details?.checkInCheckOutDetails?.checkInTime != null) {
      return "${todayCheckInOutDetails.value.details!.checkInCheckOutDetails!.checkInTime!.toLocal().hour} : ${todayCheckInOutDetails.value.details!.checkInCheckOutDetails!.checkInTime!.toLocal().minute}";
    }
    return "-";
  }

  String get getCheckOutTime {
    if(todayCheckInOutDetails.value.details?.checkInCheckOutDetails?.checkOutTime != null) {
      return "${todayCheckInOutDetails.value.details!.checkInCheckOutDetails!.checkOutTime!.toLocal().hour} : ${todayCheckInOutDetails.value.details!.checkInCheckOutDetails!.checkOutTime!.toLocal().minute}";
    }

    return "-:-";
  }

  String get getWorkingHour {
    if(checkIn.value && !checkOut.value && todayCheckInOutDetails.value.details!.checkInCheckOutDetails!.checkInTime != null) {
      return (DateTime.now().toLocal().difference(todayCheckInOutDetails.value.details!.checkInCheckOutDetails!.checkInTime!.toLocal()).inMinutes / 60).toStringAsFixed(1);
    }

    if(checkIn.value && checkOut.value && todayCheckInOutDetails.value.details!.checkInCheckOutDetails!.checkInTime != null && todayCheckInOutDetails.value.details?.checkInCheckOutDetails?.checkOutTime != null) {
      int timeDifference = (todayCheckInOutDetails.value.details!.checkInCheckOutDetails!.checkOutTime!).difference(todayCheckInOutDetails.value.details!.checkInCheckOutDetails!.checkInTime!).inMinutes;
      return ((timeDifference - (todayCheckInOutDetails.value.details?.checkInCheckOutDetails?.breakTime ?? 0)) / 60).toStringAsFixed(1);
    }

    return "-";
  }

  String get getAmount {
    if(getWorkingHour == "-") return "-";

    return (double.parse(getWorkingHour) * (todayCheckInOutDetails.value.details?.employeeDetails?.hourlyRate ?? 0)).toStringAsFixed(1);
  }

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
      "breakTime": (hour * 60) + min,
      "checkOutDistance": _getDistance,
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
      "checkInDistance": _getDistance,
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
        if(details.details == null) {
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

        if(_getDistance > 200) {
          showSlider.value = false;
          errorMsg.value = "You are ${_getDistance.toStringAsFixed(1)}m away from restaurant";
        } else {
          showSlider.value = true;
          errorMsg.value = "";
        }
      });

    });
  }

  double get _getDistance => LocationController.calculateDistance(
    targetLat: double.parse(appController.user.value.employee!.hiredByLat!),
    targetLong: double.parse(appController.user.value.employee!.hiredByLong!),
    currentLat: 23.7798035, //position.latitude,
    currentLong: 90.3627072, //position.longitude,
  );

}
