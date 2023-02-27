import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../common/shortlist_controller.dart';

class PaymentForHireController extends GetxController {
  BuildContext? context;

  final ShortlistController shortlistController = Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  void onSubmitRequestClick() {
    Get.until((route) => Get.currentRoute == Routes.clientHome);
    Get.toNamed(Routes.hireStatus);
  }

}
