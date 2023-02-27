import '../../../../../../common/utils/exports.dart';
import '../../../../../../common/widgets/custom_dialog.dart';
import '../../../../../../routes/app_pages.dart';

class RegisterEmployeeStep2Controller extends GetxController {
  BuildContext? context;

  final formKey = GlobalKey<FormState>();

  RxString selectedCountry = "United Kingdom".obs;

  Rx<List<String>> selectedLanguageList = Rx<List<String>>([]);

  TextEditingController tecPresentAddress = TextEditingController();
  TextEditingController tecPermanentAddress = TextEditingController();

  @override
  void onContinuePressed() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if(selectedLanguageList.value.isEmpty) {
        _showDialogForAcceptTermsAndCondition();
      } else {
        Get.toNamed(Routes.registerEmployeeStep3);
      }
    }
  }

  @override
  void onLanguageChange(List<String> value) {
    selectedLanguageList.value = value;
  }

  @override
  void onCountryChange(String? country) {
    selectedCountry.value = country!;
  }

  void _showDialogForAcceptTermsAndCondition() {
    CustomDialogue.information(
      context: context!,
      description: "At least one language required",
      title: 'Invalid input',
    );
  }
}
