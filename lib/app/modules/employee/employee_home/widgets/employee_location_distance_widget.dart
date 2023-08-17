import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mh/app/common/extensions/extensions.dart';
import 'package:mh/app/common/values/my_color.dart';
import 'package:mh/app/modules/employee/employee_home/controllers/employee_home_controller.dart';

class EmployeeLocationDistanceWidget extends GetWidget<EmployeeHomeController> {
  const EmployeeLocationDistanceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.showNormalText.value == true ||
          controller.singleNotification.value.hiredStatus?.toUpperCase() == "DENY" ||
          controller.loadingCurrentLocation.value ||
          controller.currentLocationDataLoaded.value == false ||
          controller.showSlider.value == true || controller.getDistance < 200) {
        return const Wrap();
      } else {
        return Container(
          margin: const EdgeInsets.only(top: 10.0),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: MyColors.c_C6A34F.withOpacity(.6),
          ),
          child: Text(
              'The restaurant is situated at a distance of ${(controller.getDistance / 1609).toStringAsFixed(1)} miles from your current location.',
              style: MyColors.white.semiBold13),
        );
      }
    });
  }
}
