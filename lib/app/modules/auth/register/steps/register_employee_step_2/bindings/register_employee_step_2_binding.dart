import 'package:get/get.dart';

import '../controllers/register_employee_step_2_controller.dart';

class RegisterEmployeeStep2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterEmployeeStep2Controller>(
      () => RegisterEmployeeStep2Controller(),
    );
  }
}
