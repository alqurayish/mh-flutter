import 'package:mh/app/common/widgets/custom_badge.dart';

import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../../../../common/widgets/custom_feature_box.dart';
import '../../../../common/widgets/custom_menu.dart';
import '../controllers/admin_home_controller.dart';

class AdminHomeView extends GetView<AdminHomeController> {
  const AdminHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return WillPopScope(
      onWillPop: () => Utils.appExitConfirmation(context),
      child: Scaffold(
        appBar: CustomAppbar.appbar(
          context: context,
          title: 'Feature',
          centerTitle: false,
          visibleBack: false,
          actions: [
            // IconButton(
            //   onPressed: controller.onNotificationClick,
            //   icon: const Icon(
            //     Icons.notifications_outlined,
            //   ),
            // ),
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
                        _restaurantName("Hi, ${controller.appController.user.value.admin?.name ?? "-"}"),
                        SizedBox(height: 20.h),

                        _promotionText,

                        SizedBox(height: 40.h),

                        Row(
                          children: [
                            Expanded(
                              child: CustomFeatureBox(
                                title: MyStrings.dashboard.tr,
                                icon: MyAssets.dashboard,
                                onTap: controller.onAdminDashboardClick,
                              ),
                            ),

                            SizedBox(width: 24.w),

                            Expanded(
                              child: Obx(
                                () => Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    CustomFeatureBox(
                                      title: "Request",
                                      icon: MyAssets.request,
                                      loading: controller.loading.value,
                                      onTap: controller.onRequestClick,
                                    ),

                                    Positioned(
                                      top: 4,
                                      right: 5,
                                      child: Visibility(
                                        visible: controller.getTotalSuggestLeft > 0,
                                        child: CustomBadge(controller.getTotalSuggestLeft.toString()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 30.h),

                        Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => Stack(
                                  children: [
                                    CustomFeatureBox(
                                      title: MyStrings.employees.tr,
                                      icon: MyAssets.myEmployees,
                                      onTap: controller.onEmployeeClick,
                                    ),

                                    Positioned(
                                      top: 4,
                                      right: 5,
                                      child: Visibility(
                                        visible: controller.unreadFromEmployee.isNotEmpty,
                                        child: CustomBadge(controller.unreadFromEmployee.length.toString()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(width: 24.w),

                            Expanded(
                              child: Obx(
                                () => Stack(
                                  children: [
                                    CustomFeatureBox(
                                      title: "Client",
                                      icon: MyAssets.kitchenPorter,
                                      onTap: controller.onClientClick,
                                    ),

                                    Positioned(
                                      top: 4,
                                      right: 5,
                                      child: Visibility(
                                        visible: controller.unreadFromClient.isNotEmpty,
                                        child: CustomBadge(controller.unreadFromClient.length.toString()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
}
