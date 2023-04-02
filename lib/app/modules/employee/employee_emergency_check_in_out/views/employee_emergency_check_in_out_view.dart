import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/employee_emergency_check_in_out_controller.dart';

class EmployeeEmergencyCheckInOutView
    extends GetView<EmployeeEmergencyCheckInOutController> {
  const EmployeeEmergencyCheckInOutView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EmployeeEmergencyCheckInOutView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EmployeeEmergencyCheckInOutView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
