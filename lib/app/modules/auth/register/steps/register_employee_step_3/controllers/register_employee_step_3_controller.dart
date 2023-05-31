import 'package:intl_phone_field/countries.dart';
import 'package:mh/app/common/controller/app_controller.dart';

import '../../../../../../common/utils/exports.dart';
import '../../../../../../common/widgets/custom_dialog.dart';
import '../../../../../../routes/app_pages.dart';

class RegisterEmployeeStep3Controller extends GetxController {
  BuildContext? context;

  final formKey = GlobalKey<FormState>();

  final AppController appController = Get.find();

  Rx<List<String>> selectedSkillList = Rx<List<String>>([]);

  TextEditingController tecEducation = TextEditingController();
  TextEditingController tecLicence = TextEditingController();
  TextEditingController tecEmergencyContact = TextEditingController();

  Country selectedCountry = countries.where((element) => element.code == "GB").first;

  void onContinuePressed() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if(selectedSkillList.value.isEmpty) {
        _showDialogForAcceptTermsAndCondition();
      } else {
        Get.toNamed(Routes.registerEmployeeStep4);
      }

    }
  }

  void onSkillChange(List<String> value) {
    selectedSkillList.value = value;
  }

  void onCountryChange(Country country) {
    selectedCountry = country;
  }

  void _showDialogForAcceptTermsAndCondition() {
    CustomDialogue.information(
      context: context!,
      description: "At least one skill required",
      title: 'Invalid input',
    );
  }
}
