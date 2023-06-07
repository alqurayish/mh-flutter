import '../../../../../../common/data/data.dart';
import '../../../../../../common/style/my_decoration.dart';
import '../../../../../../common/utils/exports.dart';
import '../../../../../../common/utils/validators.dart';
import '../../../../../../common/widgets/custom_dropdown.dart';
import '../../../../../../common/widgets/custom_multi_dropdown.dart';
import '../../../../../../common/widgets/custom_text_input_field.dart';
import '../controllers/register_employee_step_2_controller.dart';

class RegisterEmployeeStep2View extends GetView<RegisterEmployeeStep2Controller> {
  const RegisterEmployeeStep2View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    Utils.setStatusBarColorColor(Theme.of(context).brightness);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              left: -65.w,
              top: -100.h,
              child: _topLeftBg,
            ),

            Positioned(
              right: -75.w,
              bottom: -130.h,
              child: _bottomRightBg,
            ),

            _mainContent,
          ],
        ),
      ),
    );
  }

  Widget get _mainContent => Form(
        key: controller.formKey,
        child: Column(
          children: [
            SizedBox(height: 60.h),

            Image.asset(
              MyAssets.logo,
              width: 112.w,
              height: 100.h,
            ),

            SizedBox(height: 45.h),

            _pageContentTitle,

            SizedBox(height: 18.h),

            _steps,

            SizedBox(height: 30.h),

            CustomDropdown(
              prefixIcon: Icons.flag,
              hints: MyStrings.country.tr,
              value: controller.selectedCountry.value,
              items: Data.getAllCountry.map((e) => e.name).toList(),
              onChange: controller.onCountryChange,
            ),

            SizedBox(height: 26.h),

            CustomTextInputField(
              controller: controller.tecPresentAddress,
              label: MyStrings.presentAddress.tr,
              prefixIcon: Icons.location_on_rounded,
              validator: (String? value) => Validators.emptyValidator(
                value,
                MyStrings.required.tr,
              ),
            ),

            SizedBox(height: 26.h),

            CustomTextInputField(
              controller: controller.tecPermanentAddress,
              label: MyStrings.permanentAddress.tr,
              prefixIcon: Icons.location_on_rounded,
              validator: (String? value) => Validators.emptyValidator(
                value,
                MyStrings.required.tr,
              ),
            ),

            SizedBox(height: 26.h),

            SizedBox(
              height: 58.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: DropDownMultiSelect(
                  onChanged: controller.onLanguageChange,
                  options: Data.language,
                  selectedValues: controller.selectedLanguageList.value,
                  whenEmpty: MyStrings.language.tr,
                  decoration: MyDecoration.dropdownDecoration(
                    context: controller.context!,
                    prefixIcon: Icons.translate_rounded,
                    hints: MyStrings.language.tr,
                  ),
                ),
              ),
            ),


            SizedBox(height: 53.h),

            CustomButtons.button(
              text: MyStrings.continue_.tr,
              onTap: controller.onContinuePressed,
              margin: const EdgeInsets.symmetric(horizontal: 18),
            ),
          ],
        ),
      );

  Widget get _topLeftBg => Container(
        width: 180.w,
        height: 180.h,
        decoration: BoxDecoration(
          color: Theme.of(controller.context!).cardColor,
          shape: BoxShape.circle,
        ),
      );

  Widget get _pageContentTitle => Text(
        MyStrings.countryAddressLanguage.tr,
        style: Theme.of(controller.context!).textTheme.displayLarge!.copyWith(
              fontSize: 18.sp,
            ),
      );

  Widget get _steps => Padding(
        padding: const EdgeInsets.only(left: 18),
        child: Text(
          MyStrings.steps.trParams({'step': '2'}),
          style: Theme.of(controller.context!).textTheme.displaySmall!.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                fontFamily: MyAssets.fontMontserrat,
              ),
        ),
      );

  Widget get _bottomRightBg => Container(
        width: 200.w,
        height: 200.h,
        decoration: BoxDecoration(
          color: Theme.of(controller.context!).cardColor,
          shape: BoxShape.circle,
        ),
      );
}
