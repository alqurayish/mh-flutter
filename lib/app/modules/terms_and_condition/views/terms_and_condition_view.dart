import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/terms_and_condition_controller.dart';

class TermsAndConditionView extends GetView<TermsAndConditionController> {
  const TermsAndConditionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TermsAndConditionView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'TermsAndConditionView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
