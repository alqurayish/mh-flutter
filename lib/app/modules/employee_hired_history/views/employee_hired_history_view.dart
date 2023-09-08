import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/employee_hired_history_controller.dart';

class EmployeeHiredHistoryView extends GetView<EmployeeHiredHistoryController> {
  const EmployeeHiredHistoryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EmployeeHiredHistoryView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EmployeeHiredHistoryView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
