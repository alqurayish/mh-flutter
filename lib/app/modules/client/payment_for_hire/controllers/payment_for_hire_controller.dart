import '../../../../common/controller/app_controller.dart';
import '../../../../common/controller/payment_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_loader.dart';
import '../../../../enums/selected_payment_method.dart';
import '../../../../models/custom_error.dart';
import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';
import '../../client_home/controllers/client_home_controller.dart';
import '../../common/shortlist_controller.dart';

class PaymentForHireController extends GetxController {
  BuildContext? context;

  final ShortlistController shortlistController = Get.find();

  final ApiHelper _apiHelper = Get.find();

  final AppController appController = Get.find();

  final ClientHomeController _clientHomeController = Get.find();

  SelectedPaymentMethod? selectedPaymentMethod;

  void onPaymentMethodChange(SelectedPaymentMethod paymentMethod) {
    selectedPaymentMethod = paymentMethod;
  }

  Future<void> onSubmitRequestClick() async {
    // if no introduction fee then just place order
    if(shortlistController.getIntroductionFeesWithDiscount() == 0) {
      hireConfirm();
    } else {
      if(selectedPaymentMethod!.isCard) _cardPayment();
      if(selectedPaymentMethod!.isBank) _bankPayment();
    }
  }

  Future<void> hireConfirm() async {
    List<String> shortlistIds = [];

    for (var element in shortlistController.selectedForHire) {
      shortlistIds.add(element.sId!);
    }

    CustomLoader.show(context!);

    await _apiHelper.hireConfirm({"selectedShortlist": shortlistIds}).then((response) {

      CustomLoader.hide(context!);

      response.fold((CustomError customError) {

        Utils.errorDialog(context!, customError..onRetry = onSubmitRequestClick);

      }, (r) {
        shortlistController.fetchShortListEmployees();
        shortlistController.selectedForHire..clear()..refresh();
        _clientHomeController.fetchRequestEmployees();
        Get.until((route) => Get.currentRoute == Routes.clientHome);
        Get.toNamed(Routes.hireStatus);
      });
    });
  }

  Future<void> _cardPayment() async {
    final PaymentController paymentController = Get.put(PaymentController());
    paymentController.makePayment(
      amount: shortlistController.getIntroductionFeesWithDiscount(),
      currency: "EUR",
      customerName: appController.user.value.userName,
    );
  }

  void _bankPayment() {

  }

}
