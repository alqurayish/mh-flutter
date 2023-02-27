import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../interface/login_register_hints_interface.dart';

class LoginRegisterHintsController extends GetxController implements LoginRegisterHintsInterface {

  BuildContext? context;

  @override
  void onLoginPressed() {
    Get.offAndToNamed(Routes.login);
  }

  @override
  void onSignUpPressed() {
    Get.offAndToNamed(Routes.register);
  }

  @override
  void onSkipPressed() {
    Get.toNamed(Routes.mhEmployees);
  }
}
