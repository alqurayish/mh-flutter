import 'package:intl_phone_field/countries.dart';

import '../../../../common/controller/app_controller.dart';
import '../../../../common/data/data.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_dialog.dart';
import '../../../../enums/user_type.dart';
import '../../../../routes/app_pages.dart';
import '../interface/register_interface.dart';

class RegisterController extends GetxController implements RegisterInterface {
  BuildContext? context;

  final AppController appController = Get.find();

  /// user type will change when user click on employee or client
  /// or swipe page
  Rx<UserType> userType = UserType.client.obs;

  final formKeyClient = GlobalKey<FormState>();
  final formKeyEmployee = GlobalKey<FormState>();

  final PageController pageController = PageController();

  /// getter
  bool get isClientRegistration => userType.value == UserType.client;
  bool get isEmployeeRegistration => userType.value == UserType.employee;

  RxBool termsAndConditionCheck = true.obs;


  /// client information
  TextEditingController tecRestaurantName = TextEditingController();
  TextEditingController tecRestaurantAddress = TextEditingController();
  TextEditingController tecEmailAddress = TextEditingController();
  TextEditingController tecPhoneNumber = TextEditingController();
  TextEditingController tecPassword = TextEditingController();
  TextEditingController tecConfirmPassword = TextEditingController();

  /// employee information
  TextEditingController tecEmployeeFullName = TextEditingController();
  TextEditingController tecEmployeeDob = TextEditingController();
  TextEditingController tecEmployeeEmail = TextEditingController();
  TextEditingController tecEmployeePhone = TextEditingController();

  Rx<DateTime> dateOfBirth = DateTime.now().obs;

  RxString selectedGender = Data.genders.first.name!.obs;

  RxString selectedPosition = Data.positions.first.name!.obs;

  Country selectedEmployeeCountry = countries.where((element) => element.code == "GB").first;
  Country selectedClientCountry = countries.where((element) => element.code == "GB").first;


  @override
  void onInit() {
    super.onInit();
  }


  @override
  void onPageChange(int index) {
    onUserTypeClick(UserType.values[index + 1]);
  }

  @override
  void onContinuePressed() {
    Utils.unFocus();
    if (isClientRegistration) {
      _clientRegisterPressed();
    } else if (isEmployeeRegistration) {
      _employeeRegisterPressed();
    }
  }

  @override
  void onLoginPressed() {
    Get.toNamed(Routes.login);
  }

  @override
  void onTermsAndConditionCheck(bool active) {
    termsAndConditionCheck.value = active;
  }

  @override
  void onTermsAndConditionPressed() {
    Get.toNamed(Routes.termsAndCondition);
  }

  @override
  void onUserTypeClick(UserType userType) {
    if (this.userType.value != userType) {
      this.userType.value = userType;

      pageController.jumpToPage(UserType.values.indexOf(userType) - 1);
    }
  }

  @override
  void onGenderChange(String? gender) {
    selectedGender.value = gender!;
  }

  @override
  void onPositionChange(String? position) {
    selectedPosition.value = position!;
  }

  @override
  void onClientCountryChange(Country country) {
    selectedClientCountry = country;
  }

  @override
  void onEmployeeCountryChange(Country country) {
    selectedEmployeeCountry = country;
  }

  void onDatePicked(DateTime dateTime) {
    dateOfBirth.value = dateTime;
    tecEmployeeDob.text = dateTime.toString().split(" ").first.trim();
    dateOfBirth.refresh();
  }

  void _clientRegisterPressed() {
    if (formKeyClient.currentState!.validate()) {
      formKeyClient.currentState!.save();

      if(termsAndConditionCheck.value) {
        Get.toNamed(Routes.registerLastStep);
      } else {
        _showDialogForAcceptTermsAndCondition();
      }
    }
  }

  void _employeeRegisterPressed() {
    if (formKeyEmployee.currentState!.validate()) {
      formKeyEmployee.currentState!.save();

      if(termsAndConditionCheck.value) {
        Get.toNamed(Routes.registerEmployeeStep2);
      } else {
        _showDialogForAcceptTermsAndCondition();
      }
    }
  }

  void _showDialogForAcceptTermsAndCondition() {
    CustomDialogue.information(
      context: context!,
      title: "Invalid Input",
      description: "you must accept our terms and condition",
    );
  }

}
