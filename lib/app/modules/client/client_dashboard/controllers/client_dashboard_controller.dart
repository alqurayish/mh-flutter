import 'package:intl/intl.dart';
import 'package:mh/app/common/controller/app_controller.dart';
import 'package:mh/app/modules/client/common/shortlist_controller.dart';
import 'package:mh/app/repository/api_helper.dart';

import '../../../../common/utils/exports.dart';
import '../../../../models/check_in_out_histories.dart';
import '../../../../models/custom_error.dart';
import '../models/current_hired_employees.dart';
import 'package:intl/intl.dart';

class ClientDashboardController extends GetxController {
  BuildContext? context;

  final ApiHelper _apiHelper = Get.find();

  final AppController appController = Get.find();

  final List<Map<String, dynamic>> fields = [
    {"name": "Employee", "width": 143.0},
    {"name": "Check In", "width": 100.0},
    {"name": "Check Out", "width": 100.0},
    {"name": "Break Time", "width": 100.0},
    {"name": "Total Hours", "width": 100.0},
    {"name": "Chat", "width": 100.0},
    {"name": "More", "width": 100.0},
  ];

  Rx<DateTime> dashboardDate = DateTime.now().obs;
  RxString selectedDate = "".obs;

  RxBool loading = false.obs;

  Rx<HiredEmployeesByDate> hiredEmployeesByDate = HiredEmployeesByDate().obs;

  Rx<CheckInCheckOutHistory> checkInCheckOutHistory = CheckInCheckOutHistory().obs;

  RxList<CheckInCheckOutHistoryElement> history = <CheckInCheckOutHistoryElement>[].obs;

  @override
  void onInit() {
    super.onInit();
    onDatePicked(DateTime.now());

    _fetchEmployees();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  String getComment(int index) {
    return history[index].checkInCheckOutDetails?.clientComment ?? "";
  }


  void onDatePicked(DateTime dateTime) {
    dashboardDate.value = dateTime;
    dashboardDate.refresh();

    selectedDate.value = DateFormat('E, d MMM ,y').format(dashboardDate.value);

    _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    if(loading.value) return;

    loading.value = true;

    await _apiHelper.getHiredEmployeesByDate(date: dashboardDate.value.toString().split(" ").first).then((response) {

      response.fold((CustomError customError) {
        loading.value = false;

        Utils.errorDialog(context!, customError..onRetry = _fetchEmployees);

      }, (HiredEmployeesByDate hiredEmployeesByDate) {

        this.hiredEmployeesByDate.value = hiredEmployeesByDate;
        this.hiredEmployeesByDate.refresh();

        _fetchCheckInOutHistory();

      });
    });
  }

  Future<void> _fetchCheckInOutHistory() async {
    loading.value = true;

    await _apiHelper.getCheckInOutHistory(
      filterDate: dashboardDate.value.toUtc().toString().split(" ").first,
      clientId: appController.user.value.userId,
    ).then((response) {

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
