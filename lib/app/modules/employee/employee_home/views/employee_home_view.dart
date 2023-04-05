import 'package:flutter/cupertino.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../../../../common/widgets/custom_feature_box.dart';
import '../../../../common/widgets/custom_help_support.dart';
import '../../../../common/widgets/custom_menu.dart';
import '../controllers/employee_home_controller.dart';

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
            IconButton(
              onPressed: controller.onNotificationClick,
              icon: const Icon(
                Icons.notifications_outlined,
              ),
            ),
            IconButton(
              onPressed: () {
                CustomMenu.accountMenu(context);
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
              height: Get.height - 70,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            SizedBox(height: 29.h),
                            _restaurantName(MyStrings.hiRestaurant.trParams({
                              "restaurantName": controller.appController.user.value.client?.restaurantName ?? "owner of the",
                            })),
                            SizedBox(height: 20.h),

                            _promotionText,

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
                                        onTap: controller.onEmergencyCheckinCheckout,
                                      ),

                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        top: 0,
                                        bottom: 0,
                                        child: Obx(
                                          () => Visibility(
                                            visible: controller.loading.value || controller.loadingCurrentLocation.value || (controller.checkIn.value && controller.checkOut.value),
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

                            CustomHelpSupport(
                              onTap: controller.onHelpAndSupportClick,
                            ),

                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 30.h),

                    _todayDashboard,

                    SizedBox(height: 30.h),

                    Obx(
                      () => controller.loading.value
                          ? _loading("Fetching Today's Info")
                          : controller.loadingCurrentLocation.value
                              ? _loading("Get current location")
                              : controller.locationFetchError.value.isNotEmpty
                                  ? _locationFetchError
                                  : controller.errorMsg.value.isNotEmpty
                                      ? _errorMsg
                                      : _checkInCheckout,
                    ),
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

  Widget _restaurantName(String name) => Text(
    name,
    style: MyColors.l111111_dwhite(controller.context!).semiBold20,
  );

  Widget get _promotionText => Text(
    MyStrings.exploreTheFeaturesOfMhAppBelow.tr,
    style: MyColors.l777777_dtext(controller.context!).medium15,
  );

  Widget _loading(String msg) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CupertinoActivityIndicator(),
          const SizedBox(width: 10),
          Text(msg),
        ],
      );

  Widget get _locationFetchError =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning, color: Colors.amber),
          const SizedBox(width: 10),
          Text(
            controller.locationFetchError.value,
            style: MyColors.l111111_dffffff(controller.context!).regular16_5,
          ),
        ],
      );

  Widget get _errorMsg =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              controller.errorMsg.value,
              style: MyColors.l111111_dffffff(controller.context!).regular16_5,
            ),
          ),
        ],
      );

  Widget get _todayDashboard => Obx(
    () => Visibility(
      visible: controller.checkIn.value,
      child: Container(
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
      ),
    ),
  );

  Widget _itemValue(String text, String value, {double valueFontSize = 14}) => Column(
        children: [
          Text(
            value,
            style: MyColors.l7B7B7B_dtext(controller.context!).semiBold14.copyWith(
              fontSize: valueFontSize
            ),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: MyColors.l7B7B7B_dtext(controller.context!).medium12,
          ),
        ],
      );

  Widget get _checkInCheckout => Obx(
        () => Visibility(
          visible: !controller.checkIn.value || !controller.checkOut.value,
          child: SlideAction(
            key: controller.key,
            height: 74.h,
            outerColor: MyColors.c_C6A34F,
            elevation: 2,
            submittedIcon: const CircularProgressIndicator(color: Colors.white),
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
