import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AppLifecycleController extends GetxController with WidgetsBindingObserver {
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
        break;
      case AppLifecycleState.paused:
        // priority 2
        print('App paused');
        break;
      case AppLifecycleState.inactive:
        // priority 1 // call offline true
        print('App inactive');
        break;
      case AppLifecycleState.detached:
        print('App detached');
        break;
    }
  }
}