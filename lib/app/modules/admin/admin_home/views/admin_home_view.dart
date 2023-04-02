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
                                title: MyStrings.employees.tr,
                                icon: MyAssets.myEmployees,
                                onTap: controller.onEmployeeClick,
                              ),
                            ),

                            SizedBox(width: 24.w),

                            Expanded(
                              child: CustomFeatureBox(
                                title: MyStrings.dashboard.tr,
                                icon: "Client",
                                onTap: controller.onClientClick,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 30.h),

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
