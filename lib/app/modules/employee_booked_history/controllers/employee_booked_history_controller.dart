import 'package:get/get.dart';
import 'package:mh/app/modules/employee/employee_home/controllers/employee_home_controller.dart';

class EmployeeBookedHistoryController extends GetxController {
  final EmployeeHomeController employeeHomeController = Get.find<EmployeeHomeController>();

  @override
  void onInit() {
    employeeHomeController.getBookingHistory();
    super.onInit();
  }
}
