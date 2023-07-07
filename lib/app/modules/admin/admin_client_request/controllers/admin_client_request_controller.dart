import 'package:mh/app/common/widgets/custom_dialog.dart';
import 'package:mh/app/common/widgets/custom_loader.dart';
import 'package:mh/app/models/custom_error.dart';
import 'package:mh/app/modules/employee/employee_home/models/single_notification_model_for_employee.dart';
import 'package:mh/app/repository/api_helper.dart';

import '../../../../common/utils/exports.dart';
import '../../../../routes/app_pages.dart';
import '../../admin_home/controllers/admin_home_controller.dart';

class AdminClientRequestController extends GetxController {
  BuildContext? context;

  AdminHomeController adminHomeController = Get.find();
  final ApiHelper _apiHelper = Get.find();

  String getRestaurantName(int index) {
    return adminHomeController.requestedEmployees.value.requestEmployees?[index].clientDetails?.restaurantName ?? "-";
  }

  String getSuggested(int index) {
    int total = adminHomeController.getTotalRequestByPosition(index);
    int suggested = adminHomeController.getTotalSuggestByPosition(index);
    return "Already suggested $suggested of $total";
  }

  void onItemClick(int index) {
    Get.toNamed(Routes.adminClientRequestPositions, arguments: {
      MyStrings.arg.data: index,
    });
  }

  void onCancelClick({required String requestId}) {
    CustomDialogue.confirmation(
      context: context!,
      title: "Confirm Remove",
      msg: "Are you sure you want to remove this request?",
      confirmButtonText: "YES",
      onConfirm: () async {
        Get.back(); // hide confirmation dialog

        CustomLoader.show(context!);

        await _apiHelper.removeClientRequestFromAdmin(requestId: requestId).then((response) {
          CustomLoader.hide(context!);

          response.fold((CustomError customError) {
            Utils.errorDialog(context!, customError);
          }, (SingleNotificationModelForEmployee response) async {
            if ((response.statusCode == 200 || response.statusCode == 201) && response.status == 'success') {
              adminHomeController.homeMethods();
            }
          });
        });
      },
    );
  }
}
