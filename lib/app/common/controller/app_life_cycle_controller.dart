import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mh/app/common/controller/app_controller.dart';

import '../../modules/chat/one_to_one_chat/controllers/one_to_one_chat_controller.dart';

class AppLifecycleController extends GetxController with WidgetsBindingObserver {

  AppController _appController = Get.find();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // priority 3
        print('App resumed');

        if(Get.isRegistered<OneToOneChatController>()) {
          _updateActiveStatus(true);
        }

        break;
      case AppLifecycleState.paused:
        // priority 2
        print('App paused');
        break;
      case AppLifecycleState.inactive:
        // priority 1 // call offline true
        print('App inactive');
        _updateActiveStatus(false);
        break;
      case AppLifecycleState.detached:
        print('App detached');
        break;
    }
  }

  void _updateActiveStatus(bool active) {
    FirebaseFirestore.instance.collection('onChatScreen').doc(_appController.user.value.userId).set({
      "active" : active,
    });
  }
}