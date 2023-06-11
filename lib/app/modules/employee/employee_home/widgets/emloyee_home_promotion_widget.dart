import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mh/app/common/extensions/extensions.dart';
import 'package:mh/app/common/values/my_color.dart';
import 'package:mh/app/common/values/my_strings.dart';
import 'package:mh/app/modules/employee/employee_home/controllers/employee_home_controller.dart';

class EmployeeHomePromotionWidget extends GetWidget<EmployeeHomeController> {
  const EmployeeHomePromotionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.singleNotificationDataLoading.value == true) {
        return const Center(child: CupertinoActivityIndicator());
      } else {
        if (controller.showNormalText.value == true) {
          return Text(MyStrings.exploreTheFeaturesOfMhAppBelow.tr,
              style: MyColors.l777777_dtext(controller.context!).medium15);
        } else {
          return InkWell(
            onTap: controller.onHiredYouTap,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.purple.withOpacity(.6),
              ),
              child: controller.singleNotification.value.hiredStatus != null
                  ? Text(
                      "${controller.singleNotification.value.text}",
                      style: MyColors.white.semiBold16)
                  : Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                              "${controller.singleNotification.value.text}",
                              style: MyColors.white.semiBold16),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.purple.withOpacity(.45),
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: MyColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        }
      }
    });
  }
}
