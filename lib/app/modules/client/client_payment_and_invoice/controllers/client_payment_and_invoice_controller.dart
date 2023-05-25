import '../../../../common/controller/app_controller.dart';
import '../../../../common/controller/payment_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_loader.dart';
import '../../../../models/custom_error.dart';
import '../../../../repository/api_helper.dart';
import '../model/client_invoice.dart';

class ClientPaymentAndInvoiceController extends GetxController {
  BuildContext? context;

  final AppController _appController = Get.find();
  final ApiHelper _apiHelper = Get.find();
  Rx<ClientInvoice> clientInvoice = ClientInvoice().obs;

  RxBool isLoading = true.obs;

  String _selectedInvoiceId = "";

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
    _selectedInvoiceId = clientInvoice.value.invoices![index].id ?? "";
    _cardPayment(clientInvoice.value.invoices![index].amount ?? 0);
  }

  Future<void> _cardPayment(double amount) async {
    final PaymentController paymentController = Get.put(PaymentController());
    paymentController.makePayment(
      amount: amount,
      currency: "EUR",
      customerName: _appController.user.value.userName,
    );
  }

  Future<void> onPaymentSuccess() async {
    CustomLoader.show(context!);

    Map<String, dynamic> data = {
      "id": _selectedInvoiceId,
      "status": "PAID"
    };

    await _apiHelper.updatePaymentStatus(data).then((response) {
      CustomLoader.hide(context!);

      response.fold((CustomError customError) {

        Utils.errorDialog(context!, customError..onRetry = _getClientInvoice);

      }, (Response response) {

        _getClientInvoice();

      });

    });
  }
}
