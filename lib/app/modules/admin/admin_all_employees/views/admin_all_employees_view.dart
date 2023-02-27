import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_all_employees_controller.dart';

class AdminAllEmployeesView extends GetView<AdminAllEmployeesController> {
  const AdminAllEmployeesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdminAllEmployeesView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'AdminAllEmployeesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
