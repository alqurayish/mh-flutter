import 'package:dartz/dartz.dart';

import 'package:mh/app/models/custom_error.dart';

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

  void onCountryChange(String? country) {
    selectedCountry.value = country!;
  }

  void onUpdatePressed() {}

  Future<void> _getDetails() async {
    loading.value = true;

    await _apiHelper.employeeFullDetails(appController.user.value.userId).then((Either<CustomError, EmployeeFullDetails> response) {
      loading.value = false;

      response.fold((CustomError l) {
        Logcat.msg(l.msg);
      }, (r) {
        employee.value = r;
        employee.refresh();

        tecFirstName.text = employee.value.details?.firstName ?? "";
        tecLastName.text = employee.value.details?.lastName ?? "";
        tecDob.text = employee.value.details?.dateOfBirth == null
            ? ""
            : employee.value.details!.dateOfBirth.toString().split(" ").first;
        tecPhoneNumber.text = employee.value.details?.phoneNumber ?? "";
        tecEmail.text = employee.value.details?.email ?? "";
        tecPresentAddress.text = employee.value.details?.presentAddress ?? "";
        tecPermanentAddress.text = employee.value.details?.permanentAddress ?? "";
        tecEmergencyContact.text = employee.value.details?.phoneNumber ?? "";
      });
    });
  }
}
