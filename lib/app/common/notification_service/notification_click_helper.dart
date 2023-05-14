import 'dart:convert';

import '../../enums/chat_with.dart';
import '../../routes/app_pages.dart';
import '../utils/exports.dart';


class NotificationClickHelper {
  static void goToRoute(String? payload) {
    print("clicked");
    if(payload != null) {
      Map<String, dynamic> data = jsonDecode(payload);

      if (data["click_action"] == MyStrings.payloadScreen.clientEmployeeChat) {
        Get.toNamed(Routes.clientEmployeeChat, arguments: {
          MyStrings.arg.receiverName: data[MyStrings.arg.receiverName],
          MyStrings.arg.fromId: data[MyStrings.arg.fromId],
          MyStrings.arg.toId: data[MyStrings.arg.toId],
          MyStrings.arg.clientId: data[MyStrings.arg.clientId],
          MyStrings.arg.employeeId: data[MyStrings.arg.employeeId],
        });
      }
      else if (data["click_action"] == MyStrings.payloadScreen.supportChat) {
        Get.toNamed(Routes.supportChat, arguments: {
          MyStrings.arg.receiverName: data[MyStrings.arg.receiverName],
          MyStrings.arg.fromId: data[MyStrings.arg.fromId],
          MyStrings.arg.toId: data[MyStrings.arg.toId],
          MyStrings.arg.supportChatDocId: data[MyStrings.arg.supportChatDocId],
        });
      }
    } else {
      print("Payload is null");
    }
  }
}