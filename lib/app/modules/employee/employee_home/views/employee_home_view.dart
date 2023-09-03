import 'package:flutter/cupertino.dart';
import 'package:mh/app/modules/employee/employee_home/widgets/employee_home_body_widget.dart';
import 'package:mh/app/routes/app_pages.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
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
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: IconButton(
                  onPressed: controller.onCalenderClick,
                  icon: const Icon(
                    CupertinoIcons.calendar,
                  ),
                ),
              ),
              Obx(() => controller.notificationsController.unreadCount.value == 0
                  ? IconButton(
                      onPressed: () {
                        Get.toNamed(Routes.notifications, arguments: controller.appController.user.value.employee?.id??'');
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
                  CupertinoIcons.person,
                ),
              )
            ],
          ),
          body: Obx(() => controller.employeeHomeDataLoaded.value == false
              ? Center(child: Container(color: Colors.red, height: 100, width: 100,))
              : const EmployeeHomeBodyWidget())),
    );
  }
}
