import 'package:get/get.dart';

import '../controllers/block_user_controller.dart';

class BlockUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlockUserController>(
      () => BlockUserController(),
    );
  }
}
