import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@drawable/icon_notification"),
      iOS: IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: false,
        requestSoundPermission: false,
        defaultPresentSound: true,
      ),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        print("onSelectNotification");

        // if (payload!.isNotEmpty) {
        //   NotificationClickHelper.goToRoute(payload);
        // }
      },
    );

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print("FirebaseMessaging.instance.getInitialMessage");
      if (message != null) {
        print("New Notification");

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
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification?.title);
          print(message.notification?.body);
          print("message.data ${message.data}");

          LocalNotificationService.showNotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("FirebaseMessaging.onMessageOpenedApp.listen");
      if (message.notification != null) {
        print(message.notification?.title);
        print(message.notification?.body);
        print("message.data22 ${message.data}");

        // NotificationClickHelper.goToRoute(jsonEncode(message.data));
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
      print(e);
    }
  }
}
