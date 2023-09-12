import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mh/app/common/extensions/extensions.dart';
import 'package:mh/app/common/utils/exports.dart';
import 'package:mh/app/common/values/my_color.dart';
import 'package:mh/app/common/widgets/refresh_widget.dart';
import 'package:mh/app/modules/employee/employee_home/controllers/employee_home_controller.dart';

class EmployeeNameWidget extends GetWidget<EmployeeHomeController> {
  const EmployeeNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15.h),
        Row(
          children: [
            Expanded(
              flex: 10,
              child: Row(
                children: [
                  Lottie.asset(MyAssets.lottie.hiLottie, height: 60.h, width: 60.w),
                  Text(controller.appController.user.value.employee?.name ?? "-",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: MyColors.l111111_dwhite(controller.context!).semiBold18),
                ],
              ),
            ),
             SizedBox(width: 10.w),
            Expanded(flex: 1, child: RefreshWidget(onTap: controller.refreshPage))
          ],
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
