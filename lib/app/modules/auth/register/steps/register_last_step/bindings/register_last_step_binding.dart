import 'package:get/get.dart';

import '../controllers/register_last_step_controller.dart';

class RegisterLastStepBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterLastStepController>(
      () => RegisterLastStepController(),
    );
  }
}
