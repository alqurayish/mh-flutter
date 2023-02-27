import 'package:get/get.dart';

import '../controllers/payment_for_hire_controller.dart';

class PaymentForHireBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentForHireController>(
      () => PaymentForHireController(),
    );
  }
}
