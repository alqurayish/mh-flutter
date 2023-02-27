import '../../../../../../common/utils/exports.dart';
import '../../../../../../common/utils/validators.dart';
import '../../../../../../common/widgets/custom_dropdown.dart';
import '../../../../../../common/widgets/horizontal_divider_with_text.dart';
import '../controllers/register_last_step_controller.dart';

class RegisterLastStepView extends GetView<RegisterLastStepController> {
  const RegisterLastStepView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    Utils.setStatusBarColorColor(Theme.of(context).brightness);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
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

          Obx(
            () => controller.loading.value
                ? const Center(child: CircularProgressIndicator())
                : _mainContent,
          ),
        ],
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

            _almostDoneHints,

            SizedBox(height: 22.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.w),
              child: HorizontalDividerWithText(
                thickness: .5,
                child: Text(
                  MyStrings.pleaseProvideTheFollowingInfoToo.tr,
                  style: MyColors.l7B7B7B_dtext(controller.context!).medium14,
                ),
              ),
            ),

            SizedBox(height: 30.h),

            _extraInfoHeading(MyStrings.howYouKnowAboutUs.tr),

            SizedBox(height: 18.h),

            CustomDropdown(
              prefixIcon: Icons.bookmark,
              hints: null,
              value: null,
              items: (controller.sources?.sources! ?? []).map((e) => e.name).toList(),
              onChange: controller.onSourceChange,
              validator: (String? value) => Validators.emptyValidator(
                value,
                MyStrings.required.tr,
              ),
            ),

            SizedBox(height: 20.h),

            _extraInfoHeading(MyStrings.refer.tr),

            SizedBox(height: 18.h),

            CustomDropdown(
              prefixIcon: Icons.label,
              hints: null,
              value: controller.selectedRefer,
              items: (controller.employees?.users ?? []).map((e) => "${e.name} - ${e.userIdNumber}").toList()..add("Other"),
              onChange: controller.onReferChange,
              validator: (String? value) => Validators.emptyValidator(
                value,
                MyStrings.required.tr,
              ),
            ),

            SizedBox(height: 53.h),

            CustomButtons.button(
              text: MyStrings.register.tr,
              onTap: controller.onRegisterClick,
              margin: const EdgeInsets.symmetric(horizontal: 18),
            ),
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

  Widget get _almostDoneHints => Text(
        MyStrings.almostDoneRegisteringTheAccount.tr,
        style: MyColors.l111111_dwhite(controller.context!).semiBold18,
      );

  Widget _extraInfoHeading(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Text(
            text,
            style: MyColors.c_C6A34F.medium14,
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
}
