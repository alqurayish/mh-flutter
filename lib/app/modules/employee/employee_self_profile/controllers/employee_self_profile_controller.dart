import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../models/employee_full_details.dart';
import '../../../../repository/api_helper.dart';

class EmployeeSelfProfileController extends GetxController {

  BuildContext? context;

  Rx<EmployeeFullDetails> employee = EmployeeFullDetails().obs;

  final AppController appController = Get.find();
  final ApiHelper _apiHelper = Get.find();

  final formKeyClient = GlobalKey<FormState>();

  TextEditingController tecFirstName = TextEditingController();
  TextEditingController tecLastName = TextEditingController();
  TextEditingController tecPhoneNumber = TextEditingController();
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecPresentAddress = TextEditingController();
  TextEditingController tecPermanentAddress = TextEditingController();
  TextEditingController tecEmergencyContact = TextEditingController();
  TextEditingController tecDob = TextEditingController();

  RxString selectedCountry = "United Kingdom".obs;


  RxBool loading = false.obs;

  @override
  void onInit() {
    _getDetails();
    super.onInit();
  }


  @override
  void onCountryChange(String? country) {
    selectedCountry.value = country!;
  }

  void onUpdatePressed() {

  }

  Future<void> _getDetails() async {
    loading.value = true;

    await _apiHelper.employeeFullDetails(appController.user.value.userId).then((response) {

      loading.value = false;

      response.fold((l) {
        Logcat.msg(l.msg);
      }, (r) {
        employee.value = r;
        employee.refresh();
      });

    });
  }
}
