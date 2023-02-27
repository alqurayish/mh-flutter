import 'package:intl/intl.dart';

import '../../../../common/utils/exports.dart';

class ClientDashboardController extends GetxController {
  BuildContext? context;

  final List<Map<String, dynamic>> fields = [
    {"name": "Employee", "width": 143.0},
    {"name": "Check In", "width": 100.0},
    {"name": "Check Out", "width": 100.0},
    {"name": "Break Time", "width": 100.0},
    {"name": "Total Hours", "width": 100.0},
    {"name": "Chat", "width": 100.0},
    {"name": "More", "width": 100.0},
  ];

  RxList dashboardResult = [].obs;

  Rx<DateTime> dashboardDate = DateTime.now().obs;
  RxString selectedDate = "".obs;

  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    onDatePicked(DateTime.now());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onDatePicked(DateTime dateTime) {
    dashboardDate.value = dateTime;
    dashboardDate.refresh();

    selectedDate.value = DateFormat('E, d MMM ,y').format(dashboardDate.value);
  }
}
