import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mh/app/common/utils/utils.dart';
import 'package:mh/app/common/widgets/custom_dialog.dart';
import 'package:mh/app/common/widgets/custom_loader.dart';
import 'package:mh/app/models/custom_error.dart';
import 'package:mh/app/modules/client/client_home/controllers/client_home_controller.dart';
import 'package:mh/app/repository/api_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripePaymentController extends GetxController {
  late String webViewUrl;
  late WebViewController webViewController;

  final ApiHelper _apiHelper = Get.find();
  final ClientHomeController clientHomeController = Get.find();

  RxBool isLoading = true.obs;

  String cancelUrl = 'http://localhost:8000/api/cancel.html';
  late String successUrl;
  late String invoiceId;

  @override
  void onInit() {
    webViewUrl = Get.arguments[0];
    invoiceId = Get.arguments[1];
    successUrl = "http://localhost:8000/api/success?invoiceId=$invoiceId";
    loadWebView();
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

  void loadWebView() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) async {
            if (url == successUrl) {
              onPaymentSuccess();
            } else if (url == cancelUrl) {
              CustomDialogue.information(
                context: Get.context!,
                title: "Payment Failed",
                description: "Something went wrong",
              );
            }
          },
          onPageFinished: (String value) {
            isLoading.value = false;
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(webViewUrl));
  }

  Future<void> onPaymentSuccess() async {
    CustomLoader.show(Get.context!);

    Map<String, dynamic> data = {"id": invoiceId, "status": "PAID"};

    await _apiHelper.updatePaymentStatus(data).then((response) {
      CustomLoader.hide(Get.context!);

      response.fold((CustomError customError) {
        Utils.errorDialog(Get.context!, customError..onRetry = clientHomeController.getClientInvoice);
      }, (Response response) {
        clientHomeController.getClientInvoice();
      });
    });
  }
}
