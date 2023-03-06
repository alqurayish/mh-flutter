import '../../../../../../common/controller/app_controller.dart';
import '../../../../../../common/utils/exports.dart';
import '../../../../../../common/widgets/custom_dialog.dart';
import '../../../../../../common/widgets/custom_loader.dart';
import '../../../../../../enums/user_type.dart';
import '../../../../../../models/custom_error.dart';
import '../../../../../../models/employees_by_id.dart';
import '../../../../../../models/sources.dart';
import '../../../../../../repository/api_helper.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../controllers/register_controller.dart';
import '../../../models/client_register.dart';
import '../../../models/client_register_response.dart';
import '../../../models/employee_registration.dart';
import '../../register_employee_step_2/controllers/register_employee_step_2_controller.dart';
import '../../register_employee_step_3/controllers/register_employee_step_3_controller.dart';
import '../../register_employee_step_4/controllers/register_employee_step_4_controller.dart';

class RegisterLastStepController extends GetxController {
  final ApiHelper _apiHelper = Get.find();
  final AppController _appController = Get.find();
  final RegisterController _registerController = Get.find();

  BuildContext? context;

  final formKey = GlobalKey<FormState>();

  // fetch sources
  Sources? sources;
  Employees? employees;

  String selectedSource = "";
  String selectedRefer = "Other";

  RxBool loading = true.obs;

  @override
  void onInit() {
    super.onInit();

    _fetchSourceAndRefers();
  }

  Future<void> _fetchSourceAndRefers() async {

    await Future.wait([
      _apiHelper.fetchSources(),
      _apiHelper.getEmployees(isReferred: true),
    ]).then((response) {

      response[0].fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _fetchSourceAndRefers);
      }, (r) {
        sources = r as Sources;
      });

      response[1].fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _fetchSourceAndRefers);
      }, (r) {
        employees = r as Employees;
      });

      loading.value = false;

    });
  }

  String _getSourceId() {
    for (Source element in (sources?.sources ?? [])) {
      if(element.name == selectedSource) {
        return element.id;
      }
    }
    return '';
  }

  String _getReferPersonId() {
    if (selectedRefer == "Other") return "";

    for (Employee element in (employees?.users ?? [])) {
      if("${element.name} - ${element.userIdNumber}" == selectedRefer) {
        return element.id!;
      }
    }

    return "";
  }

  void onRegisterClick() {

    Utils.unFocus();

    _appController.user.value.userType = _registerController.isClientRegistration
            ? UserType.client
            : UserType.employee;

    if(_appController.user.value.isClient) {
      _clientRegistration();
    } else if(_appController.user.value.isEmployee) {
      _employeeRegistration();
    }
  }

  @override
  void onSourceChange(String? value) {
    selectedSource = value!;
  }

  @override
  void onReferChange(String? value) {
    selectedRefer = value!;
  }

  Future<void> _clientRegistration() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      ClientRegistration clientRegistration = ClientRegistration(
        restaurantName: _registerController.tecRestaurantName.text,
        restaurantAddress: _registerController.tecRestaurantAddress.text,
        email: _registerController.tecEmailAddress.text,
        phoneNumber: _registerController.selectedClientCountry.dialCode + _registerController.tecPhoneNumber.text,sourceFrom: _getSourceId(),
        referPersonId: _getReferPersonId(),
        password: _registerController.tecPassword.text,
      );

      CustomLoader.show(context!);

      await _apiHelper.clientRegister(clientRegistration).then((response) {

        CustomLoader.hide(context!);

        response.fold((CustomError customError) {
          Utils.errorDialog(context!, customError..onRetry = _clientRegistration);
        }, (ClientRegistrationResponse clientRegistrationResponse) async {
          _afterSuccessfullyRegister(clientRegistrationResponse);
        });
      });
    }
  }

  Future<void> _employeeRegistration() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      RegisterEmployeeStep2Controller step2 = Get.find();
      RegisterEmployeeStep3Controller step3 = Get.find();
      // RegisterEmployeeStep4Controller step4 = Get.find();


      EmployeeRegistration employeeRegistration = EmployeeRegistration(
          name : _registerController.tecEmployeeFullName.text.trim(),
          positionId : Utils.getPositionId(_registerController.selectedPosition.value.trim()),
          gender : _registerController.selectedGender.value.trim(),
          dateOfBirth : _registerController.dateOfBirth.value.toString().split(" ").first,
          email : _registerController.tecEmployeeEmail.text.trim(),
          phoneNumber : _registerController.selectedEmployeeCountry.dialCode + _registerController.tecEmployeePhone.text.trim(),
          countryName : step2.selectedCountry.value.trim(),
          presentAddress : step2.tecPresentAddress.text.trim(),
          permanentAddress : step2.tecPermanentAddress.text.trim(),
          language : step2.selectedLanguageList.value,
          higherEducation : step3.tecEducation.text.trim(),
          licensesNo : step3.tecLicence.text.trim(),
          emmergencyContact : step3.selectedCountry.dialCode + step3.tecEmergencyContact.text.trim(),
          skillId : Utils.getPositionId(step3.selectedSkill.value.trim()),
          sourceFrom : _getSourceId(),
          referPersonId : _getReferPersonId(),
          employeeExperience : 0,
      );

      CustomLoader.show(context!);

      await _apiHelper.employeeRegister(employeeRegistration).then((response) {

        CustomLoader.hide(context!);

        response.fold((CustomError customError) {
          Utils.errorDialog(context!, customError..onRetry = _clientRegistration);
        }, (ClientRegistrationResponse clientRegistrationResponse) async {
          _afterSuccessfullyRegister(clientRegistrationResponse);
        });
      });
    }
  }


  Future<void> _afterSuccessfullyRegister(ClientRegistrationResponse clientRegistrationResponse) async {
    if (clientRegistrationResponse.statusCode == 201) {
      await _appController.afterSuccessRegister(clientRegistrationResponse.token!);
    } else if (clientRegistrationResponse.statusCode == 400) {
      String errorTitle = "Invalid Information";
      String msg = "";

      for(var element in (clientRegistrationResponse.errors ?? []).reversed) {
        if(element.value != null) {
          msg = element.msg ?? "You Provide invalid value";
          break;
        }
      }

      CustomDialogue.information(
        context: context!,
        title: errorTitle,
        description: msg,
      );
    } else {
      CustomDialogue.information(
        context: context!,
        title: 'Error!',
        description: "Something wrong. Please try after sometime or contact us",
      );
    }
  }
}
