import 'package:mh/app/common/controller/app_controller.dart';

import '../../../../common/utils/exports.dart';
import '../../../../models/custom_error.dart';
import '../../../../repository/api_helper.dart';
import '../model/client_invoice.dart';

class ClientPaymentAndInvoiceController extends GetxController {
  BuildContext? context;

  final AppController _appController = Get.find();
  final ApiHelper _apiHelper = Get.find();
  Rx<ClientInvoice> clientInvoice = ClientInvoice().obs;

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    _getClientInvoice();
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

  Future<void> _getClientInvoice() async {

    isLoading.value = true;

    await _apiHelper.getClientInvoice(_appController.user.value.userId).then((response) {
      isLoading.value = false;

      response.fold((CustomError customError) {

        Utils.errorDialog(context!, customError..onRetry = _getClientInvoice);

      }, (ClientInvoice clientInvoice) {

        this.clientInvoice.value = clientInvoice;
        this.clientInvoice.refresh();

      });

    });
  }

  void onPayClick(int index) {

  }

  void onPaymentSuccess() {

  }
}
