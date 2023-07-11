import 'package:flutter/cupertino.dart';
import 'package:mh/app/modules/employee/employee_home/widgets/emloyee_home_promotion_widget.dart';
import 'package:mh/app/modules/employee/employee_home/widgets/employee_location_widget.dart';
import 'package:mh/app/modules/employee/employee_home/widgets/employee_todays_dashboard_widget.dart';
import 'package:mh/app/routes/app_pages.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../../../../common/widgets/custom_badge.dart';
import '../../../../common/widgets/custom_feature_box.dart';
import '../../../../common/widgets/custom_help_support.dart';
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
        body: RefreshIndicator(
          onRefresh: controller.refreshPage,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: Get.height * 0.85,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        primary: false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),
                            Text("Hi, ${controller.appController.user.value.employee?.name ?? "-"}",
                                style: MyColors.l111111_dwhite(controller.context!).semiBold20),

                            SizedBox(height: 20.h),

                            const EmployeeHomePromotionWidget(),

                           const EmployeeLocationDistanceWidget(),

                            SizedBox(height: 40.h),

                            Row(
                              children: [
                                Expanded(
                                  child: CustomFeatureBox(
                                    title: MyStrings.myDashboard.tr,
                                    icon: MyAssets.mhEmployees,
                                    onTap: controller.onDashboardClick,
                                  ),
                                ),
                                SizedBox(width: 24.w),
                                Expanded(
                                  child: Stack(
                                    children: [
                                      CustomFeatureBox(
                                        title: MyStrings.emergencyCheckInCheckOut.tr,
                                        icon: MyAssets.emergencyCheckInCheckout,
                                        iconHeight: 58.w,
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

                            SizedBox(height: 30.h),

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
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    const EmployeeTodayDashboardWidget(),
                    SizedBox(height: 30.h),
                    const EmployeeLocationWidget(),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

/*<<<<<<< HEAD
  Widget get _promotionText => Obx(() => controller.appController.user.value.employee?.isHired ?? false
      ? InkWell(
          onTap: controller.onHiredYouTap,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.purple.withOpacity(.6),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                      "${(controller.appController.user.value.employee?.hiredByRestaurantName ?? "").toUpperCase()} hired you from ${controller.appController.user.value.employee?.hiredFromDate.toString().split(" ").first} to ${controller.appController.user.value.employee?.hiredToDate.toString().split(" ").first}",
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
        )
      : Text(MyStrings.exploreTheFeaturesOfMhAppBelow.tr, style: MyColors.l777777_dtext(controller.context!).medium15));
=======
  Widget get _promotionText => Obx(() => (controller.appController.user.value.employee?.isHired ?? false) ?
      Text.rich(
    TextSpan(
        text: (controller.appController.user.value.employee?.hiredByRestaurantName ?? "").toUpperCase(),
        style: MyColors.c_C6A34F.semiBold16,
        children: [
          TextSpan(
            text: " booked  you from ",
            style: MyColors.l111111_dffffff(controller.context!).regular16,
          ),
          TextSpan(
            text: controller.appController.user.value.employee?.hiredFromDate.toString().split(" ").first,
            style: MyColors.l111111_dffffff(controller.context!).semiBold16,
          ),
          TextSpan(
            text: " to ",
            style: MyColors.l111111_dffffff(controller.context!).regular16,
          ),
          TextSpan(
            text: controller.appController.user.value.employee?.hiredToDate.toString().split(" ").first,
            style: MyColors.l111111_dffffff(controller.context!).semiBold16,
          ),
          TextSpan(
            text: ". Everyday at ",
            style: MyColors.l111111_dffffff(controller.context!).regular16,
          ),
          TextSpan(
            text: controller.appController.user.value.employee?.hiredFromTime,
            style: MyColors.l111111_dffffff(controller.context!).semiBold16,
          ),
          TextSpan(
            text: " to ",
            style: MyColors.l111111_dffffff(controller.context!).regular16,
          ),
          TextSpan(
            text: controller.appController.user.value.employee?.hiredToTime,
            style: MyColors.l111111_dffffff(controller.context!).semiBold16,
          ),
        ]
    ),
  )
      : Text(
    MyStrings.exploreTheFeaturesOfMhAppBelow.tr,
    style: MyColors.l777777_dtext(controller.context!).medium15,
  ));
>>>>>>> main*/

}
