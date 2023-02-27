import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/employee_dashboard_controller.dart';

class EmployeeDashboardView extends GetView<EmployeeDashboardController> {
  const EmployeeDashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EmployeeDashboardView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'EmployeeDashboardView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
