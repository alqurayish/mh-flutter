import 'package:mh/app/common/utils/exports.dart';
import 'package:mh/app/common/widgets/custom_appbar.dart';
import 'package:mh/app/common/widgets/no_item_found.dart';
import 'package:mh/app/modules/notifications/models/notification_response_model.dart';
import 'package:mh/app/modules/notifications/widgets/notification_widget.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
        appBar: CustomAppbar.appbar(title: 'Notifications', context: context, centerTitle: true),
        body: Obx(() {
          if (controller.notificationDataLoaded.value == false) {
            return const Center(child: CircularProgressIndicator.adaptive(backgroundColor: MyColors.c_C6A34F));
          } else if (controller.notificationDataLoaded.value == true && controller.notificationList.isEmpty) {
            return const Center(child: NoItemFound());
          } else {
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: controller.notificationList.length,
              itemBuilder: (BuildContext context, int index) {
                NotificationModel notification = controller.notificationList[index];
                return NotificationWidget(
                  notification: notification,
                );
              },
            );
          }
        }));
  }
}
