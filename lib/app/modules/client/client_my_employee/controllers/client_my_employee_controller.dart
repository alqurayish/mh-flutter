import '../../../../common/utils/exports.dart';
import '../../../../models/custom_error.dart';
import '../../../../repository/api_helper.dart';
import '../../client_dashboard/models/current_hired_employees.dart';

class ClientMyEmployeeController extends GetxController {

  BuildContext? context;

  final ApiHelper _apiHelper = Get.find();
  Rx<CurrentHiredEmployees> employees = CurrentHiredEmployees().obs;

  RxBool isLoading = true.obs;

  @override
  void onInit() {

    _getAllHiredEmployees();

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


  Future<void> _getAllHiredEmployees() async {

    isLoading.value = true;

    await _apiHelper.getAllCurrentHiredEmployees().then((response) {
      isLoading.value = false;

      response.fold((CustomError customError) {

        Utils.errorDialog(context!, customError..onRetry = _getAllHiredEmployees);

      }, (CurrentHiredEmployees employees) {

        this.employees.value = employees;
        this.employees.refresh();

      });

    });
  }
}
