import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mh/app/common/extensions/extensions.dart';
import 'package:mh/app/modules/employee/employee_home/controllers/employee_home_controller.dart';

import '../../../../common/values/my_color.dart';

class EmployeeRestaurantAddressWidget extends GetWidget<EmployeeHomeController> {
  const EmployeeRestaurantAddressWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
        visible: controller.singleNotification.value.hiredStatus?.toUpperCase() == "ALLOW",
        child: Container(
          margin: const EdgeInsets.only(top: 15.0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.teal.withOpacity(0.7),
          ),
          child: Text("The restaurant address is: ${controller.singleNotification.value.restaurantAddress ?? ''}",
              style: MyColors.white.semiBold15),
        )));
  }
}
