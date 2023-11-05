import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {

  Rx<TextEditingController> tecCurrentPassword = TextEditingController().obs;
  Rx<TextEditingController> tecNewPassword = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
