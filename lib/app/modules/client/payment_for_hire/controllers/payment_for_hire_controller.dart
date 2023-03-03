import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/utils/logcat.dart';
import '../../../../common/widgets/custom_loader.dart';
import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';
import '../../common/shortlist_controller.dart';

class PaymentForHireController extends GetxController {
  BuildContext? context;

  final ShortlistController shortlistController = Get.find();

  final ApiHelper _apiHelper = Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> onSubmitRequestClick() async {
    List<String> shortlistIds = [];

    for (var element in shortlistController.selectedForHire) {
      shortlistIds.add(element.sId!);
    }

    CustomLoader.show(context!);

    await _apiHelper.hireConfirm({"selectedShortlist": shortlistIds}).then((response) {

      CustomLoader.hide(context!);

      response.fold((l) {
        Logcat.msg(l.msg);
      }, (r) {
        shortlistController.fetchShortListEmployees();
        Get.until((route) => Get.currentRoute == Routes.clientHome);
        Get.toNamed(Routes.hireStatus);
      });
    });
  }

}
