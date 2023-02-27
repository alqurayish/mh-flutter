import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_all_clients_controller.dart';

class AdminAllClientsView extends GetView<AdminAllClientsController> {
  const AdminAllClientsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdminAllClientsView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'AdminAllClientsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
