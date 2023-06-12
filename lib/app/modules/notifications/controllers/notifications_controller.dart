import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mh/app/common/utils/utils.dart';
import 'package:mh/app/common/widgets/custom_loader.dart';
import 'package:mh/app/models/custom_error.dart';
import 'package:mh/app/modules/notifications/models/notification_response_model.dart';
import 'package:mh/app/modules/notifications/models/notification_update_request_model.dart';
import 'package:mh/app/modules/notifications/models/notification_update_response_model.dart';
import 'package:mh/app/repository/api_helper.dart';

class NotificationsController extends GetxController {
  final ApiHelper _apiHelper = Get.find();
  RxBool notificationDataLoaded = false.obs;
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;
  BuildContext? context;

  RxInt unreadCount = 0.obs;

  @override
  void onInit() {
    getNotificationList();
    super.onInit();
  }

  void getNotificationList() {
    _apiHelper.getNotifications().then((Either<CustomError, NotificationResponseModel> response) {
      response.fold((CustomError customError) {
        Utils.errorDialog(Get.context!, customError..onRetry = getNotificationList);
      }, (NotificationResponseModel responseModel) {
        if (responseModel.status == 'success' && responseModel.statusCode == 200) {
          notificationList.value = responseModel.notifications ?? [];
          _countUnread();
          notificationDataLoaded.value = true;
        }
      });
    });
  }

  void updateNotification({required String id, required bool readStatus}) {
    CustomLoader.show(context!);

    NotificationUpdateRequestModel notificationUpdateRequestModel =
        NotificationUpdateRequestModel(id: id, fromWhere: 'notifications', readStatus: readStatus);
    _apiHelper
        .updateNotification(notificationUpdateRequestModel: notificationUpdateRequestModel)
        .then((Either<CustomError, NotificationUpdateResponseModel> response) {
      CustomLoader.hide(context!);
      response.fold((CustomError customError) {
        Utils.errorDialog(context!, customError);
      }, (NotificationUpdateResponseModel responseModel) {
        if (responseModel.status == 'success' && responseModel.statusCode == 200) {
          getNotificationList();
        }
      });
    });
  }

  void _countUnread() {
    unreadCount.value = 0;
    for (var i in notificationList) {
      if (i.readStatus == false) {
        unreadCount.value += 1;
      }
    }
  }
}
