import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_break_time.dart';
import '../../../../common/widgets/custom_dialog.dart';
import '../../../../common/widgets/custom_loader.dart';
import '../../../../models/custom_error.dart';
import '../../../../repository/api_helper.dart';
import '../../employee_home/controllers/employee_home_controller.dart';
import '../../employee_home/models/today_check_in_out_details.dart';

class EmployeeEmergencyCheckInOutController extends GetxController {
  BuildContext? context;

  final ApiHelper _apiHelper = Get.find();

  final EmployeeHomeController employeeHomeController = Get.find();

  final TextEditingController emergencyReason = TextEditingController();

  final formKeyClient = GlobalKey<FormState>();

  String get getButtonText {
    if((employeeHomeController.todayCheckInOutDetails.value.details?.checkInCheckOutDetails?.checkIn ?? false) ||
        (employeeHomeController.todayCheckInOutDetails.value.details?.checkInCheckOutDetails?.emmergencyCheckIn ?? false)) {
      return "Check Out";
    }

    return "Check In";
  }

  void onCheckInCheckoutPress() {

    Utils.unFocus();

    if (formKeyClient.currentState!.validate()) {
      formKeyClient.currentState!.save();

      if(getButtonText == "Check In") {
        _checkIn();
      } else if(getButtonText == "Check Out") {
        _checkOut();
      }
    }

  }

  Future<void> _checkIn() async {
    Map<String, dynamic> data = {
      "employeeId": employeeHomeController.appController.user.value.userId,
      "emmergencyCheckIn": true,
      "emmergencyCheckInComment": emergencyReason.text.trim(),
      if(employeeHomeController.currentLocation?.latitude != null) "lat": employeeHomeController.currentLocation?.latitude.toString(),
      if(employeeHomeController.currentLocation?.longitude != null) "long": employeeHomeController.currentLocation?.longitude.toString(),
      if(employeeHomeController.currentLocation?.latitude != null && employeeHomeController.currentLocation?.longitude != null) "checkInDistance": double.parse(employeeHomeController.getDistance.toStringAsFixed(2)),
    };

    CustomLoader.show(context!);

    await _apiHelper.checkIn(data).then((response) {

      CustomLoader.hide(context!);

      response.fold((CustomError customError) {
        CustomDialogue.information(
          context: context!,
          title: "Failed to CheckIn",
          description: customError.msg,
        );
      }, (TodayCheckInOutDetails clients) {
        employeeHomeController.refreshPage();
        Get.back();
      });
    });
  }

  void _checkOut() {
    CustomBreakTime.show(context!, onBreakTimePickDone);
  }

  Future<void> onBreakTimePickDone(int hour, int min) async {
    Map<String, dynamic> data = {
      "id": employeeHomeController.todayCheckInOutDetails.value.details!.id!,
      "employeeId": employeeHomeController.appController.user.value.userId,
      "emmergencyCheckOut": true,
      "emmergencyCheckOutComment": emergencyReason.text.trim(),
      if(employeeHomeController.currentLocation?.latitude != null) "lat": employeeHomeController.currentLocation!.latitude.toString(),
      if(employeeHomeController.currentLocation?.longitude != null) "long": employeeHomeController.currentLocation?.longitude.toString(),
      "breakTime": (hour * 60) + (min * 5),
      if(employeeHomeController.currentLocation?.latitude != null && employeeHomeController.currentLocation?.longitude != null) "checkOutDistance": double.parse(employeeHomeController.getDistance.toStringAsFixed(2)),
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
        employeeHomeController.refreshPage();
        Get.back();
      });
    });
  }
}
