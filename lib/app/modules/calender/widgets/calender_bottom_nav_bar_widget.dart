import 'package:mh/app/common/utils/exports.dart';
import 'package:mh/app/common/widgets/custom_bottombar.dart';
import 'package:mh/app/modules/calender/controllers/calender_controller.dart';

class CalenderBottomNavBarWidget extends GetWidget<CalenderController> {
  const CalenderBottomNavBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => CustomBottomBar(
          child: CustomButtons.button(
            onTap: controller.disableSubmitButton == true ? null : controller.updateUnavailableDates,
            backgroundColor: controller.disableSubmitButton == true ? MyColors.c_A6A6A6 : MyColors.c_C6A34F,
            text: "Submit",
            customButtonStyle: CustomButtonStyle.radiusTopBottomCorner,
          ),
        ));
  }
}
