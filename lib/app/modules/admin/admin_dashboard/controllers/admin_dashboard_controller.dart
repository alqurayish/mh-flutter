import 'package:intl/intl.dart';

import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../models/check_in_out_histories.dart';
import '../../../../models/custom_error.dart';
import '../../../../models/employees_by_id.dart';
import '../../../../repository/api_helper.dart';

class AdminDashboardController extends GetxController {
  BuildContext? context;

  final AppController appController = Get.find();
  final ApiHelper _apiHelper = Get.find();

  RxInt uniqueClient = 0.obs;
  RxBool historyLoading = true.obs;
  RxBool clientLoading = true.obs;

  Rx<DateTime> dashboardDate = DateTime.now().obs;

  Rx<CheckInCheckOutHistory> checkInCheckOutHistory = CheckInCheckOutHistory().obs;

  RxList<CheckInCheckOutHistoryElement> history = <CheckInCheckOutHistoryElement>[].obs;

  String? requestType = "CLIENT";
  String? clientId;

  Rx<Employees> clients = Employees().obs;
  RxList<String> restaurants = ["ALL"].obs;

  RxInt hours = 0.obs;
  RxDouble amount = 0.0.obs;

  @override
  void onInit() {
    _fetchClients();
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

    // hours.value += getWorkingTimeInMinute(index) ?? 0;

    double amount = ((getWorkingTimeInMinute(index)! / 60) * (history[index].employeeDetails?.hourlyRate ?? 0));

    // this.amount.value += amount;

    return amount.toStringAsFixed(1);
  }

  void onDatePicked(DateTime dateTime) {
    dashboardDate.value = dateTime;
    dashboardDate.refresh();

    _fetchCheckInOutHistory();
  }

  @override
  void onClientChange(String? value) {
    if(value == restaurants.first) {
      clientId = null;
    } else {
      clientId = (clients.value.users ?? []).firstWhere((element) => element.restaurantName == value).id;
    }

    _fetchCheckInOutHistory();
  }

  Future<void> _fetchCheckInOutHistory() async {
    historyLoading.value = true;

    await _apiHelper.getCheckInOutHistory(
      filterDate: dashboardDate.value.toString().split(" ").first,
      clientId: clientId,
    ).then((response) {

      historyLoading.value = false;

      response.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _fetchCheckInOutHistory);
      }, (CheckInCheckOutHistory checkInCheckOutHistory) async {

        this.checkInCheckOutHistory.value = checkInCheckOutHistory;
        history.addAll(checkInCheckOutHistory.checkInCheckOutHistory ?? []);

      });
    });
  }

  Future<void> _fetchClients() async {
    clientLoading.value = true;

    await _apiHelper.getAllUsersFromAdmin(
      requestType: "CLIENT",
    ).then((response) {

      clientLoading.value = false;

      response.fold((CustomError customError) {

        Utils.errorDialog(context!, customError..onRetry = _fetchClients);

      }, (Employees clients) {

        this.clients.value = clients;
        this.clients.refresh();

        restaurants.addAll((clients.users ?? []).map((e) => e.restaurantName!).toList());

      });
    });
  }

}
