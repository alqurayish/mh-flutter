import 'package:intl_phone_field/countries.dart';

import '../../../../../../common/utils/exports.dart';
import '../../../../../../routes/app_pages.dart';

class RegisterEmployeeStep3Controller extends GetxController {
  BuildContext? context;

  final formKey = GlobalKey<FormState>();

  RxString selectedSkill = "".obs;

  Rx<List<String>> selectedLanguageList = Rx<List<String>>([]);

  TextEditingController tecEducation = TextEditingController();
  TextEditingController tecLicence = TextEditingController();
  TextEditingController tecEmergencyContact = TextEditingController();

  Country selectedCountry = countries.where((element) => element.code == "GB").first;

  @override
  void onContinuePressed() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      Get.toNamed(Routes.registerLastStep);
    }
  }

  @override
  void onSkillChange(String? skill) {
    selectedSkill.value = skill!;
  }

  @override
  void onCountryChange(Country country) {
    selectedCountry = country;
  }
}
