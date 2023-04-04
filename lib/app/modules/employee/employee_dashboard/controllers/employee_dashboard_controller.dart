import '../../../../common/utils/exports.dart';
import '../../../../models/check_in_out_histories.dart';
import '../../../../models/custom_error.dart';
import '../../../../repository/api_helper.dart';

class EmployeeDashboardController extends GetxController {
  BuildContext? context;

  final ApiHelper _apiHelper = Get.find();

  RxBool loading = true.obs;

  Rx<CheckInCheckOutHistory> checkInCheckOutHistory = CheckInCheckOutHistory().obs;

  RxList<CheckInCheckOutHistoryElement> history = <CheckInCheckOutHistoryElement>[].obs;

  @override
  void onInit() {
    _fetchCheckInOutHistory();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  String getDate(int index) {
    if(history[index].checkInCheckOutDetails?.checkInTime != null) {
      return DateTime.parse(history[index].checkInCheckOutDetails!.checkInTime!.toLocal().toString().split(" ").first).dMMMy;
    }

    return "-";
  }

  String getCheckInTime(int index) {
    if(history[index].checkInCheckOutDetails?.checkInTime != null) {
      return "${history[index].checkInCheckOutDetails!.checkInTime!.toLocal().hour} : ${history[index].checkInCheckOutDetails!.checkInTime!.toLocal().minute}";
    }
    return "-";
  }

  String getCheckOutTime(int index) {
    if(history[index].checkInCheckOutDetails?.checkOutTime != null) {
      return "${history[index].checkInCheckOutDetails!.checkOutTime!.toLocal().hour} : ${history[index].checkInCheckOutDetails!.checkOutTime!.toLocal().minute}";
    }
    return "-";
  }

  String getBreakTime(int index) {
    if(history[index].checkInCheckOutDetails?.breakTime != null) {
      return "${history[index].checkInCheckOutDetails!.breakTime}";
    }
    return "-";
  }

  int? getWorkingTimeInMinute(int index) {
    if(history[index].checkInCheckOutDetails?.checkOutTime == null) {
      return Utils.getCurrentTime.difference(history[index].checkInCheckOutDetails!.checkInTime!.toLocal()).inMinutes;
    }

    if(history[index].checkInCheckOutDetails?.checkInTime != null && history[index].checkInCheckOutDetails?.checkOutTime != null) {
      int timeDifference = (history[index].checkInCheckOutDetails!.checkOutTime!).difference(history[index].checkInCheckOutDetails!.checkInTime!).inMinutes;
      return (timeDifference - (history[index].checkInCheckOutDetails?.breakTime ?? 0));
    }

    return null;
  }

  String getAmount(int index) {
    if (getWorkingTimeInMinute(index) == null) return "-";

    return ((getWorkingTimeInMinute(index)! / 60) * (history[index].employeeDetails?.hourlyRate ?? 0)).toStringAsFixed(1);
  }

  Future<void> _fetchCheckInOutHistory() async {
    loading.value = true;

    await _apiHelper.getEmployeeCheckInOutHistory().then((response) {

      loading.value = false;

      response.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _fetchCheckInOutHistory);
      }, (CheckInCheckOutHistory checkInCheckOutHistory) async {

        this.checkInCheckOutHistory.value = checkInCheckOutHistory;
        history.addAll(checkInCheckOutHistory.checkInCheckOutHistory ?? []);

      });
    });
  }

}
