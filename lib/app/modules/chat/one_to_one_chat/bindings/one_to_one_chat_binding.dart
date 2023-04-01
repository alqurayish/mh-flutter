import 'package:get/get.dart';

import '../controllers/one_to_one_chat_controller.dart';

class OneToOneChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OneToOneChatController>(
      () => OneToOneChatController(),
    );
  }
}
