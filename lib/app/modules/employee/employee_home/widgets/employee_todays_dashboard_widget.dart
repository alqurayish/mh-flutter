import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mh/app/common/extensions/extensions.dart';
import 'package:mh/app/common/values/my_color.dart';
import 'package:mh/app/modules/employee/employee_home/controllers/employee_home_controller.dart';

class EmployeeTodayDashboardWidget extends GetWidget<EmployeeHomeController> {
  const EmployeeTodayDashboardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15.h),
        Obx(() {
          if (controller.todayDetailsDataLoaded.value == false) {
            return const Center(child: Wrap());
          } else if (controller.showTodayDashBoard == true) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  width: .5,
                  color: MyColors.c_A6A6A6,
                ),
                color: MyColors.lightCard(controller.context!),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _itemValue("Check In", controller.dailyStatistics.displayCheckInTime),
                      _itemValue("Check Out", controller.dailyStatistics.displayCheckOutTime),
                      _itemValue("Break", controller.dailyStatistics.displayBreakTime),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Divider(
                    indent: Get.width * .1,
                    endIndent: Get.width * .1,
                    color: MyColors.c_A6A6A6,
                  ),
                  const SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _itemValue("Working Time", controller.dailyStatistics.workingHour, valueFontSize: 18),
                      _itemValue("Date", controller.dailyStatistics.date, valueFontSize: 14),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Wrap();
          }
        }),
        SizedBox(height: 15.h),
      ],
    );
  }

  Widget _itemValue(String text, String value, {double valueFontSize = 14}) => Column(
        children: [
          Text(
            value,
            style: MyColors.l7B7B7B_dtext(controller.context!).semiBold14.copyWith(fontSize: valueFontSize),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: MyColors.l7B7B7B_dtext(controller.context!).medium12,
          ),
        ],
      );
}
