import 'package:dartz/dartz.dart';

import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
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
  RxBool employeeDataLoading = true.obs;

  RxInt currentPage = 1.obs;
  final ScrollController scrollController = ScrollController();
  RxBool moreDataAvailable = true.obs;

  @override
  void onInit() async {
    await _getEmployees();
    paginateTask();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
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
  ) async {
    currentPage.value = 1;
    employees.value.users?.clear();
    await _getEmployees(
        rating: selectedRating,
        experience: selectedExp,
        minTotalHour: minTotalHour,
        maxTotalHour: maxTotalHour,
        positionId: positionId);
  }

  void onResetClick() {
    Get.back();
    currentPage.value = 1;
    employees.value.users?.clear();
    _getEmployees();
  }

  Future<void> _getEmployees({
    String? rating,
    String? experience,
    String? minTotalHour,
    String? maxTotalHour,
    String? positionId,
  }) async {
    employeeDataLoading.value = true;

    Either<CustomError, Employees> response = await _apiHelper.getAllUsersFromAdmin(
        positionId: positionId,
        rating: rating,
        employeeExperience: experience,
        minTotalHour: minTotalHour,
        maxTotalHour: maxTotalHour,
        requestType: "EMPLOYEE",
        currentPage: currentPage.value);
    employeeDataLoading.value = false;

    response.fold((CustomError customError) {
      Utils.errorDialog(context!, customError..onRetry = _getEmployees);
    }, (Employees employees) {
      this.employees.value = employees;
      this.employees.refresh();
    });
  }

  void paginateTask() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        loadNextPage();
      }
    });
  }

  void onCalenderClick({required String employeeId}) {
    Get.toNamed(Routes.calender, arguments: [employeeId, '']);
  }

  void loadNextPage() async {
    currentPage.value++;
    await _getMoreEmployees();
  }

  Future<void> _getMoreEmployees({
    String? rating,
    String? experience,
    String? minTotalHour,
    String? maxTotalHour,
    String? positionId,
  }) async {
    Either<CustomError, Employees> response = await _apiHelper.getAllUsersFromAdmin(
        positionId: positionId,
        rating: rating,
        employeeExperience: experience,
        minTotalHour: minTotalHour,
        maxTotalHour: maxTotalHour,
        requestType: "EMPLOYEE",
        currentPage: currentPage.value);

    response.fold((CustomError customError) {
      moreDataAvailable.value = false;
      Utils.showSnackBar(message: 'No more employees are here...', isTrue: false);
    }, (Employees employees) {
      if (employees.users!.isNotEmpty) {
        moreDataAvailable.value = true;
      } else {
        moreDataAvailable.value = false;
        Utils.showSnackBar(message: 'No more employees are here...', isTrue: false);
      }
      this.employees.value.users?.addAll(employees.users ?? []);
      this.employees.refresh();
    });
  }
}
