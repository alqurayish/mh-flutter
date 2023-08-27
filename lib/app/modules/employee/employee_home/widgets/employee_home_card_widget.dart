import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mh/app/common/values/my_assets.dart';
import 'package:mh/app/common/values/my_strings.dart';
import 'package:mh/app/common/widgets/custom_badge.dart';
import 'package:mh/app/modules/employee/employee_home/controllers/employee_home_controller.dart';
import 'home_card_widget.dart';

class EmployeeHomeCardWidget extends GetWidget<EmployeeHomeController> {
  const EmployeeHomeCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            HomeCardWidget(
                title: MyStrings.myDashboard, imageUrl: MyAssets.mhEmployees, onTap: controller.onDashboardClick),
            Stack(
              children: [
                HomeCardWidget(
                    title: MyStrings.emergencyCheckInCheckOut.tr,
                    imageUrl: MyAssets.emergencyCheckInCheckout,
                    onTap: controller.onEmergencyCheckInCheckout),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Obx(
                    () => Visibility(
                      visible: controller.showEmergencyCheckInCheckOut == true,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey.withOpacity(.7),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            HomeCardWidget(
                title: MyStrings.paymentHistory.tr,
                imageUrl: MyAssets.invoicePayment,
                onTap: controller.onPaymentHistoryClick),
            Stack(
              children: [
                HomeCardWidget(
                    title: MyStrings.helpSupport.tr,
                    imageUrl: MyAssets.helpSupport,
                    onTap: controller.onHelpAndSupportClick),
                Obx(
                  () => Positioned(
                    top: 0,
                    right: 5,
                    child: Visibility(
                      visible: (controller.unreadMsgFromClient.value + controller.unreadMsgFromAdmin.value) > 0,
                      child: CustomBadge(
                        (controller.unreadMsgFromClient.value + controller.unreadMsgFromAdmin.value).toString(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
