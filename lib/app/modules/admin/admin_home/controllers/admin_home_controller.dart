import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mh/app/modules/notifications/controllers/notifications_controller.dart';

import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../models/custom_error.dart';
import '../../../../models/requested_employees.dart';
import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';

class AdminHomeController extends GetxController {
  final NotificationsController notificationsController = Get.find<NotificationsController>();
  BuildContext? context;

  final AppController appController = Get.find();
  final ApiHelper _apiHelper = Get.find();

  RxBool loading = true.obs;

  Rx<RequestedEmployees> requestedEmployees = RequestedEmployees().obs;

  // unread msg track
  RxInt unreadMsgFromEmployee = 0.obs;
  RxInt unreadMsgFromClient = 0.obs;

  RxList<String> chatUserIds = <String>[].obs;

  @override
  void onInit() {
    homeMethods();
    notificationsController.getNotificationList();
    super.onInit();
  }

  void onEmployeeClick() {
    Get.toNamed(Routes.adminAllEmployees);
  }

  void onClientClick() {
    Get.toNamed(Routes.adminAllClients);
  }

  void onRequestClick() {
    Get.toNamed(Routes.adminClientRequest);
  }

  void onAdminDashboardClick() {
    Get.toNamed(Routes.adminDashboard);
  }

  int getTotalRequestByPosition(int index) {
    return (requestedEmployees.value.requestEmployees?[index].clientRequestDetails ?? [])
        .fold(0, (previousValue, element) => previousValue + (element.numOfEmployee ?? 0));
  }

  int getTotalSuggestByPosition(int index) {
    return requestedEmployees.value.requestEmployees?[index].suggestedEmployeeDetails?.length ?? 0;
  }

  int get getTotalSuggestLeft {
    int total = 0;

    for (int i = 0; i < (requestedEmployees.value.requestEmployees ?? []).length; i++) {
      total += getTotalRequestByPosition(i) - getTotalSuggestByPosition(i);
    }

    return total;
  }

  Future<void> _fetchRequest() async {
    loading.value = true;

    await _apiHelper.getRequestedEmployees().then((response) {
      loading.value = false;

      response.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _fetchRequest);
      }, (RequestedEmployees requestedEmployees) async {
        this.requestedEmployees.value = requestedEmployees;
        this.requestedEmployees.refresh();
      });
    });
  }

  Future<void> reloadPage() async {
    await _fetchRequest();
  }

  void _trackUnreadMsg() {
    FirebaseFirestore.instance
        .collection('support_chat')
        .where("allAdmin_unread", isGreaterThan: 0)
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> event) {
      unreadMsgFromEmployee.value = 0;
      unreadMsgFromClient.value = 0;
      chatUserIds.clear();

      for (QueryDocumentSnapshot<Map<String, dynamic>> element in event.docs) {
        Map<String, dynamic> data = element.data();
        if (data["role"] == "CLIENT") {
          unreadMsgFromClient.value += data["allAdmin_unread"] as int;
        } else if (data["role"] == "EMPLOYEE") {
          unreadMsgFromEmployee.value += data["allAdmin_unread"] as int;
        }

        chatUserIds.add(element.id);
      }

      chatUserIds.refresh();
    });
  }

  void homeMethods() {
    _trackUnreadMsg();
    _fetchRequest();
  }
}
