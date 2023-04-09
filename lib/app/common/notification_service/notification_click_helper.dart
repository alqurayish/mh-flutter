// import 'dart:convert';
//
// import '../config/routes.dart';
// import '../config/utils.dart';
//
// class NotificationClickHelper {
//   static void goToRoute(String? payload) {
//     if(payload != null) {
//       Map<String, dynamic> data = jsonDecode(payload);
//
//       if (data["screenName"] == "SingleBillDetails") {
//         Utils.navigatorKey.currentState?.pushNamed(
//             Routes.singleBillDetails,
//             arguments: data["id"]
//         );
//       }
//     } else {
//       print("Payload is null");
//     }
//   }
// }