import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mh/app/common/controller/app_controller.dart';

import '../../modules/admin/admin_home/controllers/admin_home_controller.dart';
import '../utils/exports.dart';
import 'notification_click_helper.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@drawable/icon_notification"),
      iOS: IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        defaultPresentSound: true,
      ),
    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (kDebugMode) {
          print("onSelectNotification");
        }

        // when app running click
        if (payload!.isNotEmpty) {
          NotificationClickHelper.goToRoute(payload);
        }
      },
    );

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (kDebugMode) {
        print("FirebaseMessaging.instance.getInitialMessage");
      }
      if (message != null) {

        // NotificationClickHelper.goToRoute(jsonEncode(message.data));
        // if (message.data['_id'] != null) {
        //   Navigator.of(context).push(
        //     MaterialPageRoute(
        //       builder: (context) => DemoScreen(
        //         id: message.data['_id'],
        //       ),
        //     ),
        //   );
        // }
      }
    },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        if (kDebugMode) {
          print("FirebaseMessaging.onMessage.listen");
        }
        if (message.notification != null) {
          // print(message.notification?.title);
          // print(message.notification?.body);f
          // print("message.data ${message.data}");

          if((message.notification?.title ?? "").toLowerCase().contains("employee request")) {
            if(Get.isRegistered<AppController>()) {
              if(Get.find<AppController>().user.value.isAdmin) {
                if(Get.isRegistered<AdminHomeController>()) {
                  Get.find<AdminHomeController>().reloadPage();
                }
              }
            }
          }

          LocalNotificationService.showNotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (kDebugMode) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
      }
      if (message.notification != null) {
        // print(message.notification?.title);
        // print(message.notification?.body);
        // print("message.data22 ${message.data}");

        NotificationClickHelper.goToRoute(jsonEncode(message.data));
      }
    },
    );

  }

  static void showNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "mh_fcm_id",
          "mh_fcm_channel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
