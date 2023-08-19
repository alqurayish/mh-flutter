import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mh/app/common/extensions/extensions.dart';
import 'package:mh/app/common/values/my_color.dart';
import 'package:mh/app/modules/employee/employee_home/controllers/employee_home_controller.dart';

class EmployeeNameWidget extends GetWidget<EmployeeHomeController> {
  const EmployeeNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15.h),
        Text("Hi, ${controller.appController.user.value.employee?.name ?? "-"}",
            style: MyColors.l111111_dwhite(controller.context!).semiBold20),
        SizedBox(height: 30.h),
      ],
    );
  }
}
