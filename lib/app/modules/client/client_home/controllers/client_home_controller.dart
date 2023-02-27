import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../routes/app_pages.dart';
import '../../common/shortlist_controller.dart';

class ClientHomeController extends GetxController {
  BuildContext? context;

  final AppController appController = Get.find();
  final ShortlistController shortlistController = Get.find();

  @override
  void onMhEmployeeClick() {
    Get.toNamed(Routes.mhEmployees);
  }

  @override
  void onDashboardClick() {
    Get.toNamed(Routes.clientDashboard);
  }

  @override
  void onMyEmployeeClick() {
    Get.toNamed(Routes.clientMyEmployee);
  }

  @override
  void onInvoiceAndPaymentClick() {
    Get.toNamed(Routes.clientPaymentAndInvoice);
  }

  @override
  void onHelpAndSupportClick() {
    Get.toNamed(Routes.contactUs);
  }

  @override
  void onNotificationClick() {
    Get.toNamed(Routes.clientNotification);
  }

  void onShortlistClick() {
    Get.toNamed(Routes.clientShortlisted);
  }

}
