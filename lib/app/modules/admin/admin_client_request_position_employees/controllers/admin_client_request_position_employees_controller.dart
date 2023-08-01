import 'package:mh/app/modules/employee/employee_home/models/single_notification_model_for_employee.dart';

import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_dialog.dart';
import '../../../../common/widgets/custom_loader.dart';
import '../../../../models/custom_error.dart';
import '../../../../models/employees_by_id.dart';
import '../../../../models/requested_employees.dart';
import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';
import '../../admin_client_request_positions/controllers/admin_client_request_positions_controller.dart';
import '../../admin_home/controllers/admin_home_controller.dart';

class AdminClientRequestPositionEmployeesController extends GetxController {
  BuildContext? context;

  final AppController appController = Get.find();
  final AdminHomeController adminHomeController = Get.find();
  final AdminClientRequestPositionsController adminClientRequestPositionsController = Get.find();

  late ClientRequestDetail clientRequestDetail;

  final ApiHelper _apiHelper = Get.find();

  Rx<Employees> employees = Employees().obs;

  RxBool isLoading = false.obs;

  RxString hireStatus = "Hired".obs;

  String requestId = '';

  @override
  void onInit() {
    clientRequestDetail = Get.arguments[MyStrings.arg.data];
    super.onInit();
  }

  @override
  void onReady() {
    _getEmployees();
    super.onReady();
  }

  void onEmployeeClick(Employee employee) {
    Get.toNamed(Routes.employeeDetails, arguments: {
      MyStrings.arg.data: employee,
      MyStrings.arg.showAsAdmin: true,
    });
  }

  List<SuggestedEmployeeDetail> suggestedEmployees() {
    return (adminHomeController.requestedEmployees.value
                .requestEmployees?[adminClientRequestPositionsController.selectedIndex].suggestedEmployeeDetails ??
            [])
        .where((element) => element.positionId == clientRequestDetail.positionId)
        .toList();
  }

  bool alreadySuggest(String employeeId) {
    for (SuggestedEmployeeDetail employee in suggestedEmployees()) {
      if (employee.employeeId == employeeId) {
        return true;
      }
    }

    return false;
  }

  Future<void> onSuggestClick(Employee employee) async {
    int total = (adminHomeController.requestedEmployees.value
                    .requestEmployees?[adminClientRequestPositionsController.selectedIndex].clientRequestDetails ??
                [])
            .firstWhere((element) => element.positionId == clientRequestDetail.positionId)
            .numOfEmployee ??
        0;
    int suggested = suggestedEmployees().length;

    if (total == suggested) {
      CustomDialogue.information(
        context: context!,
        title: "Completed",
        description: "You suggest $suggested of $total employees",
      );
    } else {
      CustomLoader.show(context!);

      Map<String, dynamic> data = {
        "id": adminHomeController
            .requestedEmployees.value.requestEmployees![adminClientRequestPositionsController.selectedIndex].id,
        "employeeIds": [employee.id]
      };

      await _apiHelper.addEmployeeAsSuggest(data).then((response) {
        response.fold((CustomError customError) {
          CustomLoader.hide(context!);
          Utils.errorDialog(context!, customError);
        }, (r) async {
          if ([200, 201].contains(r.statusCode)) {
            await adminHomeController.reloadPage();
            _getEmployees();
            CustomLoader.hide(context!);
          }
        });
      });
    }
  }

  Future<void> _getEmployees({
    String? rating,
    String? experience,
    String? minTotalHour,
    String? maxTotalHour,
  }) async {
    if (isLoading.value) return;

    isLoading.value = true;

    CustomLoader.show(context!);

    await _apiHelper
        .getEmployees(
      positionId: clientRequestDetail.positionId,
      rating: rating,
      employeeExperience: experience,
      minTotalHour: minTotalHour,
      maxTotalHour: maxTotalHour,
    )
        .then((response) {
      isLoading.value = false;
      CustomLoader.hide(context!);

      response.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _getEmployees);
      }, (Employees employees) {
        this.employees.value = employees;
        this.employees.refresh();
      });
    });
  }

  void onApplyClick(
    String selectedRating,
    String selectedExp,
    String minTotalHour,
    String maxTotalHour,
    String positionId,
  ) {
    _getEmployees(
      rating: selectedRating,
      experience: selectedExp,
      minTotalHour: minTotalHour,
      maxTotalHour: maxTotalHour,
    );
  }

  void onResetClick() {
    Get.back(); // hide dialog
    _getEmployees();
  }

  void onCancelClick({required String employeeId}) {
    CustomDialogue.confirmation(
      context: context!,
      title: "Confirm Cancellation",
      msg: "Are you sure you want to cancel this suggestion?",
      confirmButtonText: "YES",
      onConfirm: () async {
        Get.back(); // hide confirmation dialog

        CustomLoader.show(context!);
        findRequestId(employeeId: employeeId);
        await _apiHelper
            .cancelEmployeeSuggestionFromAdmin(employeeId: employeeId, requestId: requestId)
            .then((response) {
          CustomLoader.hide(context!);

          response.fold((CustomError customError) {
            Utils.errorDialog(context!, customError);
          }, (SingleNotificationModelForEmployee response) async {
            if ((response.statusCode == 200 || response.statusCode == 201) && response.status == 'success') {
              _getEmployees();
              await adminHomeController.reloadPage();
            }
          });
        });
      },
    );
  }

  void findRequestId({required String employeeId}) {
    for (var i in adminHomeController.requestedEmployees.value.requestEmployees!) {
      for (var v in i.suggestedEmployeeDetails!) {
        if (v.employeeId == employeeId) {
          requestId = i.id ?? "";
          return;
        }
      }
    }
  }
}
