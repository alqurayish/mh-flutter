import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/gestures.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../common/data/data.dart';
import '../../../../common/style/my_decoration.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/utils/validators.dart';
import '../../../../common/widgets/custom_checkbox.dart';
import '../../../../common/widgets/custom_dropdown.dart';
import '../../../../common/widgets/custom_text_input_field.dart';
import '../../../../enums/user_type.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    Utils.setStatusBarColorColor(Theme.of(context).brightness);

    return WillPopScope(
      onWillPop: () => Utils.appExitConfirmation(context),
      child: Scaffold(
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
      ),
    );
  }

  Widget get _mainContent => SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40.h),

            Image.asset(
              MyAssets.logo,
              width: 73.w,
              height: 65.h,
            ),

            SizedBox(height: 30.h),

            _userType,

            SizedBox(height: 23.h),

            ExpandablePageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChange,
              children: [
                _clientInputFields,
                _employeeInputFields,
              ],
            ),

            SizedBox(height: 37.h),

            _agreeTermsAndCondition,

            SizedBox(height: 37.h),

            CustomButtons.button(
              text: MyStrings.continue_.tr,
              onTap: controller.onContinuePressed,
              margin: const EdgeInsets.symmetric(horizontal: 18),
            ),

            SizedBox(height: 52.h),

            _alreadyHaveAnAccount,

            SizedBox(height: 52.h),
          ],
        ),
      );

  Widget get _topLeftBg => Container(
        width: 180.w,
        height: 180.h,
        decoration: BoxDecoration(
          color: MyColors.lightCard(controller.context!),
          shape: BoxShape.circle,
        ),
      );

  Widget get _userType => Container(
        margin: EdgeInsets.symmetric(horizontal: 18.w),
        padding: const EdgeInsets.symmetric(horizontal: 7),
        height: 54.h,
        decoration: BoxDecoration(
          color: MyColors.lightCard(controller.context!),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: MyColors.c_A6A6A6, width: .5),
        ),
        child: Obx(
          () => Row(
            children: [
              _userItem(UserType.client, controller.userType.value == UserType.client),
              _userItem(UserType.employee, controller.userType.value == UserType.employee),
            ],
          ),
        ),
      );

  Widget _userItem(UserType userType, bool active) => Expanded(
        child: GestureDetector(
          onTap: () => controller.onUserTypeClick(userType),
          child: Container(
            height: 40.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: active
                  ? MyColors.c_C6A34F
                  : MyColors.lightCard(controller.context!),
            ),
            child: Center(
              child: Text(
                userType.name.capitalize!,
                style: active
                    ? MyColors.lightCard(controller.context!).semiBold14
                    : MyColors.darkCard(controller.context!).semiBold14,
              ),
            ),
          ),
        ),
      );

  Widget get _clientInputFields => Form(
        key: controller.formKeyClient,
        child: Column(
          children: [

            SizedBox(height: 10.h),

            CustomTextInputField(
              controller: controller.tecRestaurantName,
              label: MyStrings.restaurantName.tr,
              prefixIcon: Icons.add_business,
              validator: (String? value) => Validators.emptyValidator(
                controller.tecRestaurantName.value.text,
                MyStrings.required.tr,
              ),
            ),

            SizedBox(height: 26.h),

            CustomTextInputField(
              controller: controller.tecRestaurantAddress,
              label: MyStrings.restaurantAddress.tr,
              prefixIcon: Icons.location_on_rounded,
              validator: (String? value) => Validators.emptyValidator(
                value,
                MyStrings.required.tr,
              ),
            ),

            SizedBox(height: 26.h),

            CustomTextInputField(
              controller: controller.tecEmailAddress,
              textInputType: TextInputType.emailAddress,
              label: MyStrings.emailAddress.tr,
              prefixIcon: Icons.email_rounded,
              validator: (String? value) => Validators.emailValidator(value),
            ),

            SizedBox(height: 26.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0.w),
              child: IntlPhoneField(
                controller: controller.tecPhoneNumber,
                decoration: MyDecoration.inputFieldDecoration(
                  context: controller.context!,
                  label: MyStrings.phoneNumber.tr,
                ),
                style: MyColors.l111111_dwhite(controller.context!).regular16_5,
                dropdownTextStyle: MyColors.l111111_dwhite(controller.context!).regular16_5,
                pickerDialogStyle: PickerDialogStyle(
                  backgroundColor: MyColors.lightCard(controller.context!),
                  countryCodeStyle: MyColors.l111111_dwhite(controller.context!).regular16_5,
                  countryNameStyle: MyColors.l111111_dwhite(controller.context!).regular16_5,
                  // searchFieldCursorColor: MyColors.c_C6A34F,
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
                initialCountryCode: controller.selectedClientCountry.code,
                onCountryChanged: controller.onClientCountryChange,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),

            SizedBox(height: 26.h),

            CustomTextInputField(
              controller: controller.tecPassword,
              label: MyStrings.password.tr,
              prefixIcon: Icons.lock,
              isPasswordField: true,
              validator: (String? value) => Validators.passwordValidator(value),
            ),

            SizedBox(height: 26.h),

            CustomTextInputField(
              controller: controller.tecConfirmPassword,
              label: MyStrings.confirmPassword.tr,
              prefixIcon: Icons.lock,
              isPasswordField: true,
              validator: (String? value) => Validators.confirmPasswordValidator(
                controller.tecPassword.text,
                value ?? "",
              ),
            ),

            SizedBox(height: 10.h),
          ],
        ),
      );

  Widget get _employeeInputFields => Form(
        key: controller.formKeyEmployee,
        child: Column(
          children: [
            SizedBox(height: 10.h),

            CustomTextInputField(
              controller: controller.tecEmployeeFullName,
              label: MyStrings.fullName.tr,
              prefixIcon: Icons.person,
              validator: (String? value) => Validators.emptyValidator(
                value,
                MyStrings.required.tr,
              ),
            ),

            SizedBox(height: 26.h),

            CustomTextInputField(
              controller: controller.tecEmployeeDob,
              label: MyStrings.dateOfBirth.tr,
              prefixIcon: Icons.calendar_month,
              readOnly: true,
              onTap: () => _selectDate(controller.context!),
              validator: (String? value) => Validators.emptyValidator(
                value,
                MyStrings.required.tr,
              ),
            ),

            SizedBox(height: 26.h),

            CustomTextInputField(
              controller: controller.tecEmployeeEmail,
              textInputType: TextInputType.emailAddress,
              label: MyStrings.emailAddress.tr,
              prefixIcon: Icons.email_rounded,
              validator: (String? value) => Validators.emailValidator(value),
            ),

            SizedBox(height: 26.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0.w),
              child: IntlPhoneField(
                controller: controller.tecEmployeePhone,
                decoration: MyDecoration.inputFieldDecoration(
                  context: controller.context!,
                  label: MyStrings.phoneNumber.tr,
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
                initialCountryCode: controller.selectedEmployeeCountry.code,
                onCountryChanged: controller.onEmployeeCountryChange,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),

            SizedBox(height: 26.h),

            CustomDropdown(
              prefixIcon: Icons.sell,
              hints: MyStrings.gender.tr,
              value: controller.selectedGender.value,
              items: Data.genders.map((e) => e.name!).toList(),
              onChange: controller.onGenderChange,
            ),

            SizedBox(height: 26.h),

            CustomDropdown(
              prefixIcon: Icons.business_center,
              hints: MyStrings.position.tr,
              value: controller.selectedPosition.value,
              items: controller.appController.allActivePositions.map((e) => e.name!).toList(),
              onChange: controller.onPositionChange,
            ),

            SizedBox(height: 10.h),
          ],
        ),
  );

  Widget get _agreeTermsAndCondition => SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Obx(
                () => CustomCheckBox(
                  active: controller.termsAndConditionCheck.value,
                  onChange: controller.onTermsAndConditionCheck,
                ),
              ),
              SizedBox(width: 18.w),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: MyStrings.iAgreeToTheOf.tr,
                    style: MyColors.l50555C_dtext(controller.context!).regular15,
                    children: [
                      TextSpan(
                        text: MyStrings.termsConditions.tr,
                        style: MyColors.c_C6A34F.semiBold16,
                        recognizer: TapGestureRecognizer()..onTap = controller.onTermsAndConditionPressed,
                      ),
                      TextSpan(
                        text: "${MyStrings.mhApp.tr}  ",
                        style: MyColors.l50555C_dtext(controller.context!).regular15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget get _alreadyHaveAnAccount => Align(
        alignment: Alignment.center,
        child: Text.rich(
          TextSpan(
            text: "${MyStrings.alreadyHaveAnAccount.tr}  ",
            style: MyColors.l50555C_dtext(controller.context!).regular16,
            children: [
              TextSpan(
                text: MyStrings.login.tr,
                style: const TextStyle(
                  color: MyColors.c_C6A34F,
                  fontFamily: MyAssets.fontMontserrat,
                  fontWeight: FontWeight.w600,
                ),
                recognizer: TapGestureRecognizer()..onTap = controller.onLoginPressed,
              )
            ],
          ),
        ),
      );

  Widget get _bottomRightBg => Container(
        width: 200.w,
        height: 200.h,
        decoration: BoxDecoration(
          color: MyColors.lightCard(controller.context!),
          shape: BoxShape.circle,
        ),
      );

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.dateOfBirth.value,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != controller.dateOfBirth.value) {
      controller.onDatePicked(picked);
    }
  }
}
