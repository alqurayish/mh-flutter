import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
        if (controller.showNormalText.value == true ||
            controller.singleNotification.value.hiredStatus?.toUpperCase() == 'DENY') {
          return Text(MyStrings.exploreTheFeaturesOfMhAppBelow.tr,
              style: MyColors.l777777_dtext(controller.context!).medium15);
        } else if (controller.singleNotification.value.hiredStatus != null &&
            controller.singleNotification.value.hiredStatus?.toUpperCase() == 'ALLOW' &&
            controller.singleNotification.value.fromDate != null &&
            controller.singleNotification.value.fromTime != null &&
            controller.singleNotification.value.toDate != null &&
            controller.singleNotification.value.toTime != null) {
          return Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.purple.withOpacity(.6),
              ),
              child: Text(
                  "You have been hired from date: ${DateFormat.yMMMMd().format(controller.singleNotification.value.fromDate!)} to ${DateFormat.yMMMMd().format(controller.singleNotification.value.toDate!)} | from time ${controller.singleNotification.value.fromTime} to ${controller.singleNotification.value.toTime} by ${controller.singleNotification.value.restaurantName}",
                  style: MyColors.white.semiBold15));
        } else if (controller.singleNotification.value.hiredStatus == null ||
            controller.singleNotification.value.hiredStatus == "REQUESTED") {
          return InkWell(
            onTap: controller.onHiredYouTap,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.purple.withOpacity(.6),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: Text("${controller.singleNotification.value.text}", style: MyColors.white.semiBold15),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  const Expanded(
                    flex: 1,
                    child: CircleAvatar(
                      backgroundColor: Colors.purple,
                      child: Icon(
                        Icons.arrow_forward,
                        size: 20,
                        color: MyColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Wrap();
        }
      }
    });
  }

  TimeOfDay timeConverter({required String time}) {
    TimeOfDay timeOfDay;
    List<String> timeParts = time.split(":");
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    timeOfDay = TimeOfDay(hour: hour, minute: minute);
    return timeOfDay;
  }
}
