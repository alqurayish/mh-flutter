import '../../../../common/controller/app_controller.dart';
import '../../../../common/controller/payment_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_loader.dart';
import '../../../../models/custom_error.dart';
import '../../../../repository/api_helper.dart';
import '../../client_home/controllers/client_home_controller.dart';

class ClientPaymentAndInvoiceController extends GetxController {
  BuildContext? context;

  final AppController _appController = Get.find();
  final ApiHelper _apiHelper = Get.find();

  ClientHomeController clientHomeController = Get.find();

  String _selectedInvoiceId = "";

  void onPayClick(int index) {
    _selectedInvoiceId = clientHomeController.clientInvoice.value.invoices![index].id ?? "";
    _cardPayment(clientHomeController.clientInvoice.value.invoices![index].amount ?? 0);
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

        Utils.errorDialog(context!, customError..onRetry = clientHomeController.getClientInvoice);

      }, (Response response) {

        clientHomeController.getClientInvoice();

      });

    });
  }
}
