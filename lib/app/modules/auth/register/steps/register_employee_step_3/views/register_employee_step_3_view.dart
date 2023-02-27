import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../../../common/data/data.dart';
import '../../../../../../common/style/my_decoration.dart';
import '../../../../../../common/utils/exports.dart';
import '../../../../../../common/utils/validators.dart';
import '../../../../../../common/widgets/custom_dropdown.dart';
import '../../../../../../common/widgets/custom_text_input_field.dart';
import '../controllers/register_employee_step_3_controller.dart';

class RegisterEmployeeStep3View extends GetView<RegisterEmployeeStep3Controller> {
  const RegisterEmployeeStep3View({Key? key}) : super(key: key);

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

        CustomTextInputField(
          controller: controller.tecEducation,
          label: MyStrings.education.tr,
          prefixIcon: Icons.history_edu,
          validator: (String? value) => Validators.emptyValidator(
            value,
            MyStrings.required.tr,
          ),
        ),

        SizedBox(height: 26.h),

        CustomTextInputField(
          controller: controller.tecLicence,
          textInputType: TextInputType.number,
          label: MyStrings.licensesNo.tr,
          prefixIcon: Icons.history_edu,
          validator: (String? value) => Validators.emptyValidator(
            value,
            MyStrings.required.tr,
          ),
        ),

        SizedBox(height: 26.h),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0.w),
          child: IntlPhoneField(
            controller: controller.tecEmergencyContact,
            decoration: MyDecoration.inputFieldDecoration(
              context: controller.context!,
              label: MyStrings.emergencyContact.tr,
            ),
            style: MyColors.l111111_dwhite(controller.context!).regular16_5,
            dropdownTextStyle: MyColors.l111111_dwhite(controller.context!).regular16_5,
            pickerDialogStyle: PickerDialogStyle(
              backgroundColor: MyColors.lightCard(controller.context!),
              countryCodeStyle: MyColors.l111111_dwhite(controller.context!).regular16_5,
              countryNameStyle: MyColors.l111111_dwhite(controller.context!).regular16_5,
              searchFieldCursorColor: MyColors.c_C6A34F,
              searchFieldInputDecoration: const InputDecoration(
                suffixIcon: Icon(Icons.search),
                labelText: "Search Country",
                labelStyle: TextStyle(
                  fontFamily: MyAssets.fontMontserrat,
                  fontWeight: FontWeight.w400,
                  color: MyColors.c_7B7B7B,
                ),
                floatingLabelStyle: TextStyle(
                  fontFamily: MyAssets.fontMontserrat,
                  fontWeight: FontWeight.w600,
                  color: MyColors.c_C6A34F,
                ),
              ),
            ),
            initialCountryCode: controller.selectedCountry.code,
            onCountryChanged: controller.onCountryChange,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),

        SizedBox(height: 26.h),

        CustomDropdown(
          prefixIcon: Icons.history_edu,
          hints: MyStrings.skills.tr,
          value: controller.selectedSkill.value,
          items: Data.skills.map((e) => e.name!).toList(),
          onChange: controller.selectedSkill,
          validator: (String? value) => Validators.emptyValidator(
            value,
            MyStrings.required.tr,
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
    MyStrings.educationLicenseSkill.tr,
    style: Theme.of(controller.context!).textTheme.headline1!.copyWith(
      fontSize: 18.sp,
    ),
  );

  Widget get _steps => Padding(
    padding: const EdgeInsets.only(left: 18),
    child: Text(
      MyStrings.steps.trParams({'step': '3'}),
      style: Theme.of(controller.context!).textTheme.headline3!.copyWith(
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
