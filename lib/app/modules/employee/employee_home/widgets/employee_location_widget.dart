import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mh/app/common/extensions/extensions.dart';
import 'package:mh/app/common/values/my_color.dart';
import 'package:mh/app/modules/employee/employee_home/controllers/employee_home_controller.dart';
import 'package:mh/app/modules/employee/employee_home/widgets/employee_check_in_checkout_widget.dart';

class EmployeeLocationWidget extends GetWidget<EmployeeHomeController> {
  const EmployeeLocationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.loading.value
          ? _loading("Fetching Today's Info")
          : controller.loadingCurrentLocation.value
              ? _loading("Get current location")
              : (controller.appController.user.value.employee?.isHired ?? false)
                  ? controller.isTodayInBetweenFromDateAndToDate
                      ? controller.locationFetchError.value.isNotEmpty
                          ? _locationFetchError
                          : controller.errorMsg.value.isNotEmpty
                              ? const Wrap() //_errorMsg
                              : const EmployeeCheckInCheckoutWidget()
                      : const Wrap()
                  /*  _massage(
                                          "you hired from ${controller.appController.user.value.employee?.hiredFromDate.toString().split(" ").first} to ${controller.appController.user.value.employee?.hiredToDate.toString().split(" ").first}")*/
                  : _massage("You have not been hired yet"),
    );
  }

  Widget _loading(String msg) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CupertinoActivityIndicator(),
          const SizedBox(width: 10),
          _massage(msg),
        ],
      );

  Widget _massage(String msg) => Text(
        msg,
        textAlign: TextAlign.center,
        style: MyColors.l111111_dffffff(controller.context!).regular12,
      );

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

  Widget get _errorMsg => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info, color: Colors.blue),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              controller.errorMsg.value,
              style: MyColors.l111111_dffffff(controller.context!).regular16_5,
            ),
          ),
        ],
      );
}
