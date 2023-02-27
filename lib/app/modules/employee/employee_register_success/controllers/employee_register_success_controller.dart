import 'package:get/get.dart';

import '../../../../common/controller/app_controller.dart';
import '../../../../enums/user_type.dart';
import '../../../../routes/app_pages.dart';

class EmployeeRegisterSuccessController extends GetxController {
  final AppController _appController = Get.find();

  @override
  void onGetStartedClick() {
    if (_appController.user.value.userType == UserType.client) {
      Get.offAndToNamed(Routes.clientHome);
    } else if (_appController.user.value.userType == UserType.employee) {
      Get.offAndToNamed(Routes.mhEmployees);
    }
  }
}
