import 'package:mh/app/common/widgets/custom_dialog.dart';

import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/client_help_option.dart';
import '../../../../common/widgets/custom_loader.dart';
import '../../../../enums/chat_with.dart';
import '../../../../models/custom_error.dart';
import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';
import '../../common/shortlist_controller.dart';

class ClientHomeController extends GetxController {
  BuildContext? context;

  final AppController appController = Get.find();
  final ShortlistController shortlistController = Get.find();
  final ApiHelper _apiHelper = Get.find();

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
    ClientHelpOption.show(context!);
  }

  @override
  void onNotificationClick() {
    Get.toNamed(Routes.clientNotification);
  }

  @override
  void chatWithAdmin() {
    Get.back(); // hide dialogue

    Get.toNamed(Routes.oneToOneChat, arguments: {
      MyStrings.arg.chatWith: ChatWith.admin,
    });
  }

  @override
  void requestEmployees() {
    Get.back(); // hide dialogue

    Get.toNamed(Routes.clientRequestForEmployee);
  }

  void onShortlistClick() {
    Get.toNamed(Routes.clientShortlisted);
  }

  Future<void> onAccountDeleteClick() async {
    CustomDialogue.confirmation(
      context: context!,
      title: "Confirm Delete",
      msg: "Are you sure you want to delete account? \n\n Once you delete your account you can't access and you lost all of your data",
      confirmButtonText: "Delete",
      onConfirm: () async {

        Get.back(); // hide confirmation dialog

        CustomLoader.show(context!);

        Map<String, dynamic> data = {
          "id": appController.user.value.userId,
          "active": false,
          "deactivatedReason": "Account deactivate by user(${appController.user.value.userId})"
        };

        await _apiHelper.deleteAccount(data).then((response) {
          CustomLoader.hide(context!);

          response.fold((CustomError customError) {
            Utils.errorDialog(context!, customError..onRetry = onAccountDeleteClick);
          }, (Response deleteResponse) async {
            appController.onLogoutClick();
          });

        });
      },
    );

  }

}
