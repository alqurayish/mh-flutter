import 'package:dartz/dartz.dart';
import 'package:mh/app/models/nationality_model.dart';
import 'package:mh/app/models/position.dart';

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

  RxList<NationalityDetailsModel> nationalityList = <NationalityDetailsModel>[].obs;

  /* RxInt currentPage = 1.obs;
  final ScrollController scrollController = ScrollController();
  RxBool moreDataAvailable = true.obs;*/

  @override
  void onInit() async {
    await _getEmployees();
    await getNationalityList();
    //paginateTask();
    super.onInit();
  }

  @override
  void onClose() {
    //scrollController.dispose();
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
    Iterable<Position> positions = appController.allActivePositions.where((element) => element.id == positionId);

    if (positions.isEmpty) return MyAssets.defaultImage;

    return positions.first.logo!;
  }

  void onApplyClick(
    String selectedRating,
    String selectedExp,
    String minTotalHour,
    String maxTotalHour,
    String positionId,
    String dressSize,
    String nationality,
    String minHeight,
    String maxHeight,
    String hourlyRate,
  ) async {
    //currentPage.value = 1;
    employees.value.users?.clear();
    await _getEmployees(
        rating: selectedRating,
        experience: selectedExp,
        minTotalHour: minTotalHour,
        maxTotalHour: maxTotalHour,
        positionId: positionId,
        dressSize: dressSize,
        nationality: nationality,
        minHeight: minHeight,
        maxHeight: maxHeight,
        hourlyRate: hourlyRate);
  }

  void onResetClick() {
    Get.back();
    //currentPage.value = 1;
    employees.value.users?.clear();
    _getEmployees();
  }

  Future<void> _getEmployees({
    String? rating,
    String? experience,
    String? minTotalHour,
    String? maxTotalHour,
    String? positionId,
    String? dressSize,
    String? nationality,
    String? minHeight,
    String? maxHeight,
    String? hourlyRate,
  }) async {
    employeeDataLoading.value = true;

    Either<CustomError, Employees> response = await _apiHelper.getAllUsersFromAdmin(
        positionId: positionId,
        rating: rating,
        employeeExperience: experience,
        minTotalHour: minTotalHour,
        maxTotalHour: maxTotalHour,
        requestType: "EMPLOYEE");
    employeeDataLoading.value = false;

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
  }

/*  void paginateTask() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        loadNextPage();
      }
    });
  }*/

  void onCalenderClick({required String employeeId}) {
    Get.toNamed(Routes.calender, arguments: [employeeId, '']);
  }

  /*void loadNextPage() async {
    currentPage.value++;
    await _getMoreEmployees();
  }*/

  /* Future<void> _getMoreEmployees({
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
    );

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
  }*/

  Future<void> getNationalityList() async {
    Either<CustomError, NationalityModel> response = await _apiHelper.getNationalities();
    response.fold((CustomError customError) {
      Utils.errorDialog(context!, customError);
    }, (NationalityModel responseData) {
      nationalityList.value = responseData.nationalities ?? [];
      nationalityList.refresh();
    });
  }
}
