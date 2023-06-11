import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mh/app/common/utils/exports.dart';
import 'package:mh/app/modules/notifications/models/notification_response_model.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationModel notification;
  const NotificationWidget({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: ListTile(
        title: Text('${notification.text}'),
        leading: const CircleAvatar(
          backgroundColor: MyColors.c_111111,
          child: Icon(CupertinoIcons.bell, color: MyColors.c_C6A34F),
        ),
        subtitle: Text(
            '${DateFormat.yMMMMd().format(notification.createdAt!)}, ${DateFormat.jm().format(notification.createdAt!)}'),
      ),
    );
  }
}
