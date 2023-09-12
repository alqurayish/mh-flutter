import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_loader.dart';
import '../../../../models/custom_error.dart';
import '../../../../models/employees_by_id.dart';
import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';
import '../../admin_home/controllers/admin_home_controller.dart';

class AdminAllEmployeesController extends GetxController {
  BuildContext? context;

  final AppController appController = Get.find();
  final AdminHomeController adminHomeController = Get.find();
  final ApiHelper _apiHelper = Get.find();

  Rx<Employees> employees = Employees().obs;

  RxBool isLoading = false.obs;

  @override
  void onReady() {
    _getEmployees();
    super.onReady();
  }

  void onEmployeeClick(Employee employee) {
    Get.toNamed(Routes.employeeDetails, arguments: {
      MyStrings.arg.data: employee,
      MyStrings.arg.showAsAdmin: true,
      MyStrings.arg.fromWhere: 'admin_home_view'
    });
  }

  void onChatClick(Employee employee) {
    Get.toNamed(Routes.supportChat, arguments: {
      MyStrings.arg.fromId: appController.user.value.userId,
      MyStrings.arg.toId: employee.id ?? "",
      MyStrings.arg.supportChatDocId: employee.id ?? "",
      MyStrings.arg.receiverName: employee.firstName ?? "-",
    });
  }

  String getPositionLogo(String positionId) {
    var positions = appController.allActivePositions.where((element) => element.id == positionId);

    if (positions.isEmpty) return MyAssets.defaultImage;

    return positions.first.logo!;
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
        positionId: positionId);
  }

  void onResetClick() {
    Get.back(); // hide modal
    _getEmployees();
  }

  Future<void> _getEmployees({
    String? rating,
    String? experience,
    String? minTotalHour,
    String? maxTotalHour,
    String? positionId,
  }) async {
    if (isLoading.value) return;

    isLoading.value = true;

    await _apiHelper
        .getAllUsersFromAdmin(
      positionId: positionId,
      rating: rating,
      employeeExperience: experience,
      minTotalHour: minTotalHour,
      maxTotalHour: maxTotalHour,
      requestType: "EMPLOYEE",
    )
        .then((response) {
      isLoading.value = false;

      response.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _getEmployees);
      }, (Employees employees) {
        this.employees.value = employees;

        for (int i = 0; i < (this.employees.value.users ?? []).length; i++) {
          var item = this.employees.value.users![i];
          if (adminHomeController.chatUserIds.contains(item.id)) {
            this.employees.value.users?.removeAt(i);
            this.employees.value.users?.insert(0, item);
          }
        }

        this.employees.refresh();
      });
    });
  }

  void onCalenderClick({required String employeeId}) {
    Get.toNamed(Routes.calender, arguments: [employeeId, '']);
  }
}
