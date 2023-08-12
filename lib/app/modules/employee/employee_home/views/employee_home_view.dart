import 'package:flutter/cupertino.dart';
import 'package:mh/app/modules/employee/employee_home/widgets/emloyee_home_promotion_widget.dart';
import 'package:mh/app/modules/employee/employee_home/widgets/employee_location_widget.dart';
import 'package:mh/app/modules/employee/employee_home/widgets/employee_restaurant_address_widget.dart';
import 'package:mh/app/modules/employee/employee_home/widgets/employee_todays_dashboard_widget.dart';
import 'package:mh/app/routes/app_pages.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../../../../common/widgets/custom_badge.dart';
import '../../../../common/widgets/custom_feature_box.dart';
import '../../../../common/widgets/custom_menu.dart';
import '../controllers/employee_home_controller.dart';
import '../widgets/employee_location_distance_widget.dart';

class EmployeeHomeView extends GetView<EmployeeHomeController> {
  const EmployeeHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return WillPopScope(
      onWillPop: () => Utils.appExitConfirmation(context),
      child: Scaffold(
        appBar: CustomAppbar.appbar(
          context: context,
          title: 'Features',
          centerTitle: false,
          visibleBack: false,
          actions: [
            Obx(() => controller.notificationsController.unreadCount.value == 0
                ? IconButton(
                    onPressed: () {
                      Get.toNamed(Routes.notifications);
                    },
                    icon: const Icon(CupertinoIcons.bell))
                : InkWell(
                    onTap: () {
                      Get.toNamed(Routes.notifications);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 15.h, right: 15.w),
                      child: Badge(
                        backgroundColor: MyColors.c_C6A34F,
                        label: Obx(() {
                          return Text(controller.notificationsController.unreadCount.toString(),
                              style: const TextStyle(color: MyColors.c_FFFFFF));
                        }),
                        child: const Icon(CupertinoIcons.bell),
                      ),
                    ),
                  )),
            IconButton(
              onPressed: () {
                CustomMenu.accountMenu(
                  context,
                  onProfileTap: controller.onProfileClick,
                );
              },
              icon: const Icon(
                Icons.person_outline_rounded,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: RefreshIndicator(
            onRefresh: controller.refreshPage,
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Flexible(
                      flex: 4,
                      child: SingleChildScrollView(
                        primary: false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15.h),
                            Text("Hi, ${controller.appController.user.value.employee?.name ?? "-"}",
                                style: MyColors.l111111_dwhite(controller.context!).semiBold20),
                            SizedBox(height: 30.h),
                            const EmployeeHomePromotionWidget(),
                            const EmployeeLocationDistanceWidget(),
                            const EmployeeRestaurantAddressWidget(),
                            SizedBox(height: 20.h),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomFeatureBox(
                                    title: MyStrings.myDashboard.tr,
                                    icon: MyAssets.mhEmployees,
                                    onTap: controller.onDashboardClick,
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                Expanded(
                                  child: Stack(
                                    children: [
                                      CustomFeatureBox(
                                        title: MyStrings.emergencyCheckInCheckOut.tr,
                                        icon: MyAssets.emergencyCheckInCheckout,
                                        onTap: controller.onEmergencyCheckInCheckout,
                                      ),
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        top: 0,
                                        bottom: 0,
                                        child: Obx(
                                          () => Visibility(
                                            visible: (controller.appController.user.value.employee?.isHired ?? false)
                                                ? (controller.loading.value ||
                                                    controller.loadingCurrentLocation.value ||
                                                    (controller.checkIn.value && controller.checkOut.value) ||
                                                    !controller.isTodayInBetweenFromDateAndToDate)
                                                : true,
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
                                    onTap: controller.onPaymentHistoryClick,
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                Expanded(
                                  child: Stack(
                                    children: [
                                      CustomFeatureBox(
                                        onTap: controller.onHelpAndSupportClick,
                                        title: MyStrings.helpSupport.tr,
                                        icon: MyAssets.helpSupport,
                                      ),
                                      Obx(
                                        () => Positioned(
                                          top: 0,
                                          right: 5,
                                          child: Visibility(
                                            visible: (controller.unreadMsgFromClient.value +
                                                    controller.unreadMsgFromAdmin.value) >
                                                0,
                                            child: CustomBadge(
                                              (controller.unreadMsgFromClient.value +
                                                      controller.unreadMsgFromAdmin.value)
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
                            /* SizedBox(height: 30.h),
                            Stack(
                              children: [
                                CustomHelpSupport(
                                  onTap: controller.onHelpAndSupportClick,
                                ),
                                Obx(
                                  () => Positioned(
                                    top: 0,
                                    right: 5,
                                    child: Visibility(
                                      visible:
                                          (controller.unreadMsgFromClient.value + controller.unreadMsgFromAdmin.value) >
                                              0,
                                      child: CustomBadge(
                                        (controller.unreadMsgFromClient.value + controller.unreadMsgFromAdmin.value)
                                            .toString(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),*/
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: SingleChildScrollView(
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(height: 15.h),
                              const EmployeeTodayDashboardWidget(),
                              SizedBox(height: 15.h),
                              const EmployeeLocationWidget(),
                              SizedBox(height: 15.h),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
