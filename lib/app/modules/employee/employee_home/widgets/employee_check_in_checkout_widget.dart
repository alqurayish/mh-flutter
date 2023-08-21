import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mh/app/modules/employee/employee_home/controllers/employee_home_controller.dart';
import 'package:mh/app/modules/employee/employee_home/widgets/slide_able_widget.dart';

class EmployeeCheckInCheckoutWidget extends GetWidget<EmployeeHomeController> {
  const EmployeeCheckInCheckoutWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideAbleWidget(checkIn: controller.checkIn.value, onSubmit: controller.onCheckInCheckOut);
  }
}
