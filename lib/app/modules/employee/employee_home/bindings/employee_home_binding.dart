import 'package:get/get.dart';

import '../controllers/employee_home_controller.dart';

class EmployeeHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployeeHomeController>(
      () => EmployeeHomeController(),
    );
  }
}
