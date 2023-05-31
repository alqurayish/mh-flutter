import '../../../../common/utils/exports.dart';
import '../../../../models/custom_error.dart';
import '../../../../repository/api_helper.dart';
import '../../client_dashboard/models/current_hired_employees.dart';
import '../../common/shortlist_controller.dart';

class ClientMyEmployeeController extends GetxController {

  BuildContext? context;

  final ApiHelper _apiHelper = Get.find();
  final ShortlistController shortlistController = Get.find();

  Rx<HiredEmployeesByDate> employees = HiredEmployeesByDate().obs;

  RxBool isLoading = true.obs;

  @override
  void onInit() {

    _getAllHiredEmployees();

    super.onInit();
  }

  Future<void> _getAllHiredEmployees() async {

    isLoading.value = true;

    await _apiHelper.getHiredEmployeesByDate().then((response) {
      isLoading.value = false;

      response.fold((CustomError customError) {

        Utils.errorDialog(context!, customError..onRetry = _getAllHiredEmployees);

      }, (HiredEmployeesByDate employees) {

        this.employees.value = employees;
        this.employees.refresh();

      });

    });
  }
}
