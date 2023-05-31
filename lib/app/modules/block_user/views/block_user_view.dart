import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/block_user_controller.dart';

class BlockUserView extends GetView<BlockUserController> {
  const BlockUserView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BlockUserView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BlockUserView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
