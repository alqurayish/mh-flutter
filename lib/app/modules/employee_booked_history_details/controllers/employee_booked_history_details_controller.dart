import 'package:get/get.dart';
import 'package:mh/app/modules/employee/employee_home/controllers/employee_home_controller.dart';
import 'package:mh/app/modules/notifications/models/notification_response_model.dart';

class EmployeeBookedHistoryDetailsController extends GetxController {
  late NotificationModel bookingHistory;

  final EmployeeHomeController employeeHomeController = Get.find<EmployeeHomeController>();

  @override
  void onInit() {
    bookingHistory = Get.arguments;
    super.onInit();
  }
}
