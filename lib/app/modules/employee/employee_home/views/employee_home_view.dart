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
        body: SizedBox(
          height: double.infinity,
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
                              child: CustomFeatureBox(
                                title: MyStrings.emergencyCheckInCheckOut.tr,
                                icon: MyAssets.emergencyCheckInCheckout,
                                iconHeight: 58.w,
                                onTap: controller.onEmergencyCheckinCheckout,
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

                _checkInCheckout,

                SizedBox(height: 30.h),
              ],
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

  Widget get _checkInCheckout => Obx(
        () => Visibility(
          visible: controller.checkIn.value || controller.checkOut.value,
          child: SlideAction(
            key: controller.key,
            height: 74.h,
            outerColor: MyColors.c_C6A34F,
            elevation: 2,
            submittedIcon: const CircularProgressIndicator(color: Colors.white),
            onSubmit: controller.onCheckInCheckOut,
            reversed: controller.checkOut.value,
            child: Text(
              controller.checkIn.value
                  ? "Slide to check In  >>"
                  : "<<  Slide to check Out",
              textAlign: TextAlign.center,
              style: MyColors.black.semiBold18,
            ),
          ),
        ),
      );

}
