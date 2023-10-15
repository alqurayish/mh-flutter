import 'package:dartz/dartz.dart';

import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../models/custom_error.dart';
import '../../../../models/employees_by_id.dart';
import '../../../../models/position.dart';
import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';
import '../../common/shortlist_controller.dart';

class MhEmployeesByIdController extends GetxController {
  BuildContext? context;

  final AppController _appController = Get.find();
  final ShortlistController shortlistController = Get.find();
  final ApiHelper _apiHelper = Get.find();

  late Position position;

  Rx<Employees> employees = Employees().obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    position = Get.arguments[MyStrings.arg.data];
    super.onInit();
  }

  @override
  void onReady() {
    _getEmployees();
    super.onReady();
  }

  Future<void> onBookNowClick(Employee employee) async {
    if (!_appController.hasPermission()) return;
    Get.toNamed(Routes.calender, arguments: [employee.id ?? '', shortListId(employeeId: employee.id ?? '')]);
  }

  void onEmployeeClick(Employee employee) {
    Get.toNamed(Routes.employeeDetails, arguments: {
      MyStrings.arg.data: employee,
      MyStrings.arg.showAsAdmin: false,
      MyStrings.arg.fromWhere: MyStrings.arg.mhEmployeeViewByIdText
    });
  }

  Future<void> _getEmployees(
      {String? rating,
      String? experience,
      String? minTotalHour,
      String? maxTotalHour,
      String? dressSize,
      String? nationality,
      String? height,
      String? hourlyRate}) async {
    if (isLoading.value) return;

    isLoading.value = true;

    await _apiHelper
        .getEmployees(
            positionId: position.id,
            rating: rating,
            employeeExperience: experience,
            minTotalHour: minTotalHour,
            maxTotalHour: maxTotalHour,
            dressSize: dressSize,
            nationality: nationality,
            height: height,
            hourlyRate: hourlyRate)
        .then((Either<CustomError, Employees> response) {
      isLoading.value = false;

      response.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _getEmployees);
      }, (Employees employees) {
        this.employees.value = employees;
        this.employees.refresh();
      });
    });
  }

  void onApplyClick(String selectedRating, String selectedExp, String minTotalHour, String maxTotalHour,
      String positionId, String dressSize, String nationality, String height, String hourlyRate) {
    _getEmployees(
        rating: selectedRating,
        experience: selectedExp,
        minTotalHour: minTotalHour,
        maxTotalHour: maxTotalHour,
        dressSize: dressSize,
        nationality: nationality,
        hourlyRate: hourlyRate,
        height: height);
  }

  void onResetClick() {
    Get.back(); // hide dialog
    _getEmployees();
  }

  void goToShortListedPage() {
    Get.toNamed(Routes.clientShortlisted);
  }

  String shortListId({required String employeeId}) {
    for (var i in shortlistController.shortList) {
      if (i.employeeId == employeeId) {
        return i.sId ?? '';
      }
    }
    return '';
  }
}
