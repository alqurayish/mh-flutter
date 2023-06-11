import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mh/app/common/utils/exports.dart';
import 'package:mh/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:mh/app/modules/notifications/models/notification_response_model.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationModel notification;
  const NotificationWidget({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.find<NotificationsController>()
            .updateNotification(id: notification.id ?? '', readStatus: notification.readStatus ?? true);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: ListTile(
          title: Text(
            '${notification.text}',
            style: TextStyle(color: notification.readStatus == true ? MyColors.c_7B7B7B : MyColors.c_111111),
          ),
          leading: const CircleAvatar(
            backgroundColor: MyColors.c_111111,
            child: Icon(CupertinoIcons.bell, color: MyColors.c_C6A34F),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
                '${DateFormat.yMMMMd().format(notification.createdAt!)}, ${DateFormat.jm().format(notification.createdAt!)}',
                style: const TextStyle(fontStyle: FontStyle.italic)),
          ),
        ),
      ),
    );
  }
}
