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
    return Wrap();

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
