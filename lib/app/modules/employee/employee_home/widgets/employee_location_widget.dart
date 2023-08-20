import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mh/app/common/extensions/extensions.dart';
import 'package:mh/app/common/values/my_color.dart';
import 'package:mh/app/modules/employee/employee_home/controllers/employee_home_controller.dart';
import 'package:mh/app/modules/employee/employee_home/widgets/employee_check_in_checkout_widget.dart';

class EmployeeLocationWidget extends GetWidget<EmployeeHomeController> {
  const EmployeeLocationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          if (controller.singleNotificationDataLoaded.value == false ||
              controller.todayDetailsDataLoaded.value == false) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (controller.locationFetchError.value.isNotEmpty) {
            return _locationFetchError;
          } else if (controller.showCheckInCheckOutWidget == true) {
            return const EmployeeCheckInCheckoutWidget();
          } else if (controller.singleNotification.value.hiredStatus?.toUpperCase() == "ALLOW" &&
              controller.appController.user.value.employee?.isHired == true) {
            return const Wrap();
          } else if (controller.singleNotification.value.hiredStatus?.toUpperCase() == "REQUESTED" ||
              controller.singleNotification.value.hiredStatus?.toUpperCase() == null ||
              controller.appController.user.value.employee?.isHired == false) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 300),
              child: Text('You have not been hired yet', style: MyColors.l111111_dwhite(context).semiBold15),
            ));
          } else {
            return const Wrap();
          }
        }),
        SizedBox(height: 15.h),
      ],
    );
  }

  Widget get _locationFetchError => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning, color: Colors.amber),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              controller.locationFetchError.value,
              style: MyColors.l111111_dffffff(controller.context!).regular16_5,
            ),
          ),
        ],
      );
}
