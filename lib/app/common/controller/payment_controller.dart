import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:mh/app/common/widgets/custom_dialog.dart';
import 'package:mh/app/common/widgets/custom_loader.dart';

import '../../modules/client/client_payment_and_invoice/controllers/client_payment_and_invoice_controller.dart';
import '../../modules/client/payment_for_hire/controllers/payment_for_hire_controller.dart';
import '../app_info/app_credentials.dart';
import 'app_error_controller.dart';

class PaymentController extends GetxController {
  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment({
    required double amount,
    required String currency,
    required String customerName,
  }) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);

      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
          // applePay: true,
          // googlePay: true,
          merchantDisplayName: customerName,
          customerId: paymentIntentData!['customer'],
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
            // customFlow: true,
            style: ThemeMode.dark,
            primaryButtonLabel: "Pay Now",
        )).then((value) {
          displayPaymentSheet();
        });
      }
    } catch (e, s) {
      CustomLoader.hide(Get.context!);
      if (kDebugMode) {
        print('exception:$e $s');
      }
    }
  }

  displayPaymentSheet() async {
    try {
      CustomLoader.hide(Get.context!);
      await Stripe.instance.presentPaymentSheet().then((value) {
          if(Get.isRegistered<PaymentForHireController>()) {
            Get.find<PaymentForHireController>().hireConfirm();
          } else if(Get.isRegistered<ClientPaymentAndInvoiceController>()) {
            Get.find<ClientPaymentAndInvoiceController>().onPaymentSuccess();
          }
      });

    } on Exception catch (e) {

      if (e is StripeException) {
        CustomDialogue.information(
          context: Get.context!,
          title: "Payment Failed",
          description: e.error.localizedMessage.toString(),
        );

        if(!["The payment flow has been canceled"].contains(e.error.localizedMessage.toString())) {
          AppErrorController.submitAutomaticError(
            errorName: "From: payment_controller.dart > createPaymentIntent",
            description: e.error.localizedMessage.toString(),
          );
        }

      } else {
        CustomDialogue.information(
          context: Get.context!,
          title: "Payment Failed",
          description: "Something Wrong",
        );
        AppErrorController.submitAutomaticError(
          errorName: "From: payment_controller.dart > createPaymentIntent",
          description: e.toString(),
        );
      }


    } catch (e) {
      CustomLoader.hide(Get.context!);
      if (kDebugMode) {
        print("exception:$e");
      }
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(double amount, String currency) async {

    try {
      CustomLoader.show(Get.context!);
      var response = await Dio().post(
          'https://api.stripe.com/v1/payment_intents?amount=${(amount * 100).toInt()}&currency=$currency&payment_method_types[]=card',
          options: Options(
            headers: {
              'Authorization': 'Bearer ${AppCredentials.stripeSecretKey}',
              'Content-Type': 'application/x-www-form-urlencoded'
            },
          ));

      return response.data as Map<String, dynamic>;
    } catch(e) {

      CustomLoader.hide(Get.context!);

      await Future.delayed(const Duration(milliseconds: 500));

      CustomDialogue.information(
        context: Get.context!,
        title: "Failed to payment",
        description: "Failed to Payment",
      );

      AppErrorController.submitAutomaticError(
        errorName: "From: payment_controller.dart > createPaymentIntent",
        description: e.toString(),
      );

      return null;
    }
  }
}