import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:mh/app/modules/client/client_payment_and_invoice/model/client_invoice.dart';
import 'package:mh/app/modules/stripe_payment/models/stripe_request_model.dart';
import 'package:mh/app/modules/stripe_payment/models/stripe_response_model.dart';
import 'package:mh/app/routes/app_pages.dart';
import '../../../../common/controller/app_controller.dart';
import '../../../../common/controller/payment_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_loader.dart';
import '../../../../models/custom_error.dart';
import '../../../../repository/api_helper.dart';
import '../../client_home/controllers/client_home_controller.dart';

class ClientPaymentAndInvoiceController extends GetxController {
  BuildContext? context;

  File? invoiceFile;

  final AppController _appController = Get.find();
  final ApiHelper _apiHelper = Get.find();

  ClientHomeController clientHomeController = Get.find();

  String _selectedInvoiceId = "";

  void onPayClick(int index) {
    _selectedInvoiceId = clientHomeController.clientInvoice.value.invoices![index].id ?? "";
    // _cardPayment(clientHomeController.clientInvoice.value.invoices![index].amount ?? 0);
    makeStripePayment(
        stripeRequestModel: StripeRequestModel(
            amount: clientHomeController.clientInvoice.value.invoices![index].amount ?? 0,
            invoiceId: _selectedInvoiceId,
            currency: _appController.user.value.client?.countryName == 'United Kingdom' ? 'gbp' : 'aed'));
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

    Map<String, dynamic> data = {"id": _selectedInvoiceId, "status": "PAID"};

    await _apiHelper.updatePaymentStatus(data).then((response) {
      CustomLoader.hide(context!);

      response.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = clientHomeController.getClientInvoice);
      }, (Response response) {
        clientHomeController.getClientInvoice();
      });
    });
  }

  void onViewInvoicePress({required Invoice invoice}) async {
    invoiceFile = await Utils.generatePdfWithImageAndText(invoice: invoice);
    Get.toNamed(Routes.invoicePdf, arguments: [invoiceFile]);
  }

  void makeStripePayment({required StripeRequestModel stripeRequestModel}) {
    CustomLoader.show(context!);
    _apiHelper
        .stripePayment(stripeRequestModel: stripeRequestModel)
        .then((Either<CustomError, StripeResponseModel> response) {
      CustomLoader.hide(context!);
      response.fold((CustomError customError) {
        Utils.errorDialog(Get.context!, customError..onRetry);
      }, (StripeResponseModel response) {
        if (response.status == 'success' &&
            response.details != null &&
            response.details?.url != null &&
            response.details!.url!.isNotEmpty) {
          Get.toNamed(Routes.stripePayment, arguments: [response.details, _selectedInvoiceId]);
        }
      });
    });
  }
}
