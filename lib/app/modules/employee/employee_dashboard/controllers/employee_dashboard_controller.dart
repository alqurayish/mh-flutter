import '../../../../common/utils/exports.dart';
import '../../../../models/check_in_out_histories.dart';
import '../../../../models/custom_error.dart';
import '../../../../models/employee_daily_statistics.dart';
import '../../../../repository/api_helper.dart';

class EmployeeDashboardController extends GetxController {
  BuildContext? context;

  final ApiHelper _apiHelper = Get.find();

  RxBool loading = true.obs;

  Rx<CheckInCheckOutHistory> checkInCheckOutHistory = CheckInCheckOutHistory().obs;

  RxList<CheckInCheckOutHistoryElement> history = <CheckInCheckOutHistoryElement>[].obs;

  @override
  void onInit() {
    _fetchCheckInOutHistory();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  String getComment(int index) {
    return history[index].checkInCheckOutDetails?.clientComment ?? "";
  }

  Future<void> _fetchCheckInOutHistory() async {
    loading.value = true;

    await _apiHelper.getEmployeeCheckInOutHistory().then((response) {

      loading.value = false;

      response.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _fetchCheckInOutHistory);
      }, (CheckInCheckOutHistory checkInCheckOutHistory) async {

        this.checkInCheckOutHistory.value = checkInCheckOutHistory;
        history.addAll(checkInCheckOutHistory.checkInCheckOutHistory ?? []);

      });
    });
  }

}
