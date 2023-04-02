import 'package:get/get.dart';

import '../controllers/employee_emergency_check_in_out_controller.dart';

class EmployeeEmergencyCheckInOutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployeeEmergencyCheckInOutController>(
      () => EmployeeEmergencyCheckInOutController(),
    );
  }
}
