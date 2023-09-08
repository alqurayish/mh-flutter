import '../../../../common/style/my_decoration.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/utils/validators.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../../../../common/widgets/custom_bottombar.dart';
import '../controllers/employee_emergency_check_in_out_controller.dart';

class EmployeeEmergencyCheckInOutView extends GetView<EmployeeEmergencyCheckInOutController> {
  const EmployeeEmergencyCheckInOutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
      appBar: CustomAppbar.appbar(
        context: context,
        title: 'Emergency ${controller.getButtonText}',
      ),
      bottomNavigationBar: _bottomBar(context),
      body: Form(
        key: controller.formKeyClient,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                controller.employeeHomeController.appController.user.value.employee?.hiredByRestaurantName ?? "--",
                style: MyColors.c_C6A34F.semiBold22,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                controller.employeeHomeController.appController.user.value.employee?.hiredByRestaurantAddress ?? "--",
                style: MyColors.l7B7B7B_dtext(context).regular16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextFormField(
                controller: controller.emergencyReason,
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: null,
                cursorColor: MyColors.c_C6A34F,
                style: MyColors.l111111_dwhite(context).regular16,
                decoration: MyDecoration.inputFieldDecoration(
                  context: context,
                  label: "Why Emergency",
                ),
                validator: (String? value) => Validators.emptyValidator(
                  value?.trim(),
                  MyStrings.required.tr,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar(BuildContext context) => CustomBottomBar(
        child: CustomButtons.button(
          onTap: //controller.onCheckInCheckoutPress
              null,
          text: controller.getButtonText,
          customButtonStyle: CustomButtonStyle.radiusTopBottomCorner,
        ),
      );
}
