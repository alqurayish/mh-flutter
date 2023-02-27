import 'package:get/get.dart';

import '../controllers/register_employee_step_4_controller.dart';

class RegisterEmployeeStep4Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterEmployeeStep4Controller>(
      () => RegisterEmployeeStep4Controller(),
    );
  }
}
