import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';

class AdminHomeController extends GetxController {
  BuildContext? context;

  final AppController appController = Get.find();
  final ApiHelper _apiHelper = Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onEmployeeClick() {
    Get.toNamed(Routes.adminAllEmployees);
  }

  @override
  void onClientClick() {
    Get.toNamed(Routes.adminAllClients);
  }

  @override
  void onAdminDashboardClick() {
    Get.toNamed(Routes.adminDashboard);
  }
}
