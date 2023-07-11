import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mh/app/common/extensions/extensions.dart';
import 'package:mh/app/common/values/my_color.dart';
import 'package:mh/app/modules/employee/employee_home/controllers/employee_home_controller.dart';
import 'package:mh/app/modules/employee/employee_home/widgets/slide_action_widget.dart';

class EmployeeCheckInCheckoutWidget extends GetWidget<EmployeeHomeController> {
  const EmployeeCheckInCheckoutWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Visibility(
        visible: (!controller.checkIn.value || !controller.checkOut.value) &&
            (controller.appController.user.value.employee?.isHired ?? false),
        child: SlideActionWidget(
          key: controller.key,
          height: 74.h,
          outerColor: MyColors.c_C6A34F,
          elevation: 2,
          submittedIcon: const CircularProgressIndicator.adaptive(backgroundColor: Colors.white),
          onSubmit: controller.onCheckInCheckOut,
          reversed: controller.checkIn.value,
          child: Text(
            !controller.checkIn.value && !controller.checkOut.value
                ? "Slide to check In  >>"
                : "<<  Slide to check Out",
            textAlign: TextAlign.center,
            style: MyColors.white.semiBold18,
          ),
        ),
      ),
    );
  }
}
