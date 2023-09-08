import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mh/app/common/values/my_assets.dart';
import 'package:mh/app/common/values/my_strings.dart';
import 'package:mh/app/common/widgets/custom_badge.dart';
import 'package:mh/app/common/widgets/custom_feature_box.dart';
import 'package:mh/app/common/widgets/shimmer_widget.dart';
import 'package:mh/app/modules/employee/employee_home/controllers/employee_home_controller.dart';
import 'home_card_widget.dart';

class EmployeeHomeCardWidget extends GetWidget<EmployeeHomeController> {
  const EmployeeHomeCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.bookingHistoryDataLoaded.value == false
        ? ShimmerWidget.employeeHomeShimmerWidget()
        : Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        CustomFeatureBox(
                            title: MyStrings.bookedHistory,
                            icon: MyAssets.bookedHistory,
                            onTap: controller.onBookedHistoryClick),
                        Obx(
                          () => Positioned(
                            top: 0,
                            right: 5,
                            child: Visibility(
                              visible: controller.bookingHistoryList
                                  .where((e) => e.hiredStatus?.toUpperCase() == 'REQUESTED')
                                  .toList()
                                  .isNotEmpty,
                              child: CustomBadge(
                                controller.bookingHistoryList
                                    .where((e) => e.hiredStatus?.toUpperCase() == 'REQUESTED')
                                    .toList()
                                    .length
                                    .toString(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 24.w),
                  Expanded(
                    child: Stack(
                      children: [
                        CustomFeatureBox(
                            title: MyStrings.hiredHistory,
                            icon: MyAssets.hiredHistory,
                            onTap: controller.onHiredHistoryClick),
                        Obx(
                          () => Positioned(
                            top: 0,
                            right: 5,
                            child: Visibility(
                              visible: controller.bookingHistoryList
                                  .where((e) => e.hiredStatus?.toUpperCase() == 'ALLOW')
                                  .toList()
                                  .isNotEmpty,
                              child: CustomBadge(
                                controller.bookingHistoryList
                                    .where((e) => e.hiredStatus?.toUpperCase() == 'ALLOW')
                                    .toList()
                                    .length
                                    .toString(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  Expanded(
                    child: CustomFeatureBox(
                        title: MyStrings.myDashboard, icon: MyAssets.mhEmployees, onTap: controller.onDashboardClick),
                  ),
                  SizedBox(width: 24.w),
                  Expanded(
                    child: Stack(
                      children: [
                        CustomFeatureBox(
                            title: MyStrings.emergencyCheckInCheckOut.tr,
                            icon: MyAssets.emergencyCheckInCheckout,
                            onTap: controller.onEmergencyCheckInCheckout),
                        /* Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Obx(
                      () => Visibility(
                        visible: true, //controller.showEmergencyCheckInCheckOut == true,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey.withOpacity(.7),
                          ),
                        ),
                      ),
                    ),
                  )*/
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  Expanded(
                    child: CustomFeatureBox(
                        title: MyStrings.paymentHistory.tr,
                        icon: MyAssets.invoicePayment,
                        onTap: controller.onPaymentHistoryClick),
                  ),
                  SizedBox(width: 24.w),
                  Expanded(
                    child: Stack(
                      children: [
                        CustomFeatureBox(
                            title: MyStrings.helpSupport.tr,
                            icon: MyAssets.helpSupport,
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
                  ),
                ],
              ),
            ],
          ));
  }
}
