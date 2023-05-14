import 'package:mh/app/modules/admin/admin_home/controllers/admin_home_controller.dart';

import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_loader.dart';
import '../../../../enums/chat_with.dart';
import '../../../../models/custom_error.dart';
import '../../../../models/employees_by_id.dart';
import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';

class AdminAllClientsController extends GetxController {
  BuildContext? context;

  final AppController appController = Get.find();
  final AdminHomeController adminHomeController = Get.find();
  final ApiHelper _apiHelper = Get.find();

  Rx<Employees> clients = Employees().obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    _getClients();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> _getClients() async {
    if (isLoading.value) return;

    isLoading.value = true;

    CustomLoader.show(context!);

    await _apiHelper.getAllUsersFromAdmin(
      requestType: "CLIENT",
    ).then((response) {

      isLoading.value = false;
      CustomLoader.hide(context!);

      response.fold((CustomError customError) {

        Utils.errorDialog(context!, customError..onRetry = _getClients);

      }, (Employees clients) {

        this.clients.value = clients;
        this.clients.refresh();

      });
    });
  }

  void onChatClick(Employee employee) {
    Get.toNamed(Routes.supportChat, arguments: {
      MyStrings.arg.fromId: appController.user.value.userId,
      MyStrings.arg.toId: employee.id ?? "",
      MyStrings.arg.supportChatDocId: employee.id ?? "",
      MyStrings.arg.receiverName: employee.restaurantName ?? "-",
    });
  }
}
