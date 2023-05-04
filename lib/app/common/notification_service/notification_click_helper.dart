import 'dart:convert';

import '../../enums/chat_with.dart';
import '../../routes/app_pages.dart';
import '../utils/exports.dart';


class NotificationClickHelper {
  static void goToRoute(String? payload) {
    print("clicked");
    if(payload != null) {
      Map<String, dynamic> data = jsonDecode(payload);

      if (data["click_action"] == "ONE_TO_ONE_CHAT") {
        // Utils.navigatorKey.currentState?.pushNamed(
        //     Routes.singleBillDetails,
        //     arguments: data["id"]
        // );

        Get.toNamed(Routes.oneToOneChat, arguments: {
          MyStrings.arg.chatWith: data["chat_with"] == "ADMIN" ? ChatWith.admin : data["chat_with"] == "CLIENT" ? ChatWith.client : ChatWith.employee,
          MyStrings.arg.receiverId: data["send_from"],
          MyStrings.arg.receiverName: data["sender_name"],
        });
      }
    } else {
      print("Payload is null");
    }
  }
}