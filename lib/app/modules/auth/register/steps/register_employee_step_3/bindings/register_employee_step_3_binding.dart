import 'package:get/get.dart';

import '../controllers/register_employee_step_3_controller.dart';

class RegisterEmployeeStep3Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterEmployeeStep3Controller>(
      () => RegisterEmployeeStep3Controller(),
    );
  }
}
