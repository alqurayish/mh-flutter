import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:mh/app/common/utils/utils.dart';
import 'package:mh/app/models/custom_error.dart';
import 'package:mh/app/modules/notifications/models/notification_response_model.dart';
import 'package:mh/app/repository/api_helper.dart';

class NotificationsController extends GetxController {
  final ApiHelper _apiHelper = Get.find();
  RxBool notificationDataLoaded = false.obs;
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;

  @override
  void onInit() {
    _getNotificationList();
    super.onInit();
  }

  void _getNotificationList() {
    _apiHelper.getNotifications().then((Either<CustomError, NotificationResponseModel> response) {
      response.fold((CustomError customError) {
        print('NotificationsController._getNotificationList: ${customError.msg}');
        Utils.errorDialog(Get.context!, customError..onRetry = _getNotificationList);
      }, (NotificationResponseModel responseModel) {
        if (responseModel.status == 'success' && responseModel.statusCode == 200) {
          notificationList.value = responseModel.notifications ?? [];
          notificationDataLoaded.value = true;
        }
      });
    });
  }
}
