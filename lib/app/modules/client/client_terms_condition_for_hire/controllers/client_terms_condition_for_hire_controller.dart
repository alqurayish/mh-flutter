import 'package:get/get.dart';

import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';
import '../models/terms_condition_for_hire.dart';

class ClientTermsConditionForHireController extends GetxController with StateMixin<TermsConditionForHire> {

  final ApiHelper _apiHelper = Get.find();

  @override
  void onInit() {
    _fetchTermsCondition();
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

  Future<void> _fetchTermsCondition() async {

    change(null, status: RxStatus.loading());

    await _apiHelper.getTermsConditionForHire().then((response) {
      response.fold((l) {

        change(null, status: RxStatus.error(l.msg));

      }, (TermsConditionForHire termsConditionForHire) {

        change(termsConditionForHire, status: RxStatus.success());

      });
    });
  }

  void onMakePaymentClick() {
    Get.toNamed(Routes.payment);
  }
}
