import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/client_help_option.dart';
import '../../../../common/widgets/custom_dialog.dart';
import '../../../../common/widgets/custom_loader.dart';
import '../../../../enums/chat_with.dart';
import '../../../../models/custom_error.dart';
import '../../../../models/requested_employees.dart';
import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';
import '../../common/shortlist_controller.dart';

class ClientHomeController extends GetxController {
  BuildContext? context;

  final AppController appController = Get.find();
  final ShortlistController shortlistController = Get.find();
  final ApiHelper _apiHelper = Get.find();

  Rx<RequestedEmployees> requestedEmployees = RequestedEmployees().obs;

  // unread msg track
  RxInt unreadMsgFromEmployee = 0.obs;
  RxInt unreadMsgFromAdmin = 0.obs;

  RxList<Map<String, dynamic>> employeeChatDetails = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    _trackUnreadMsg();
    _fetchRequestEmployees();
    super.onInit();
  }

  @override
  void onMhEmployeeClick() {
    Get.toNamed(Routes.mhEmployees);
  }

  @override
  void onDashboardClick() {
    Get.toNamed(Routes.clientDashboard);
  }

  @override
  void onMyEmployeeClick() {
    Get.toNamed(Routes.clientMyEmployee);
  }

  @override
  void onInvoiceAndPaymentClick() {
    Get.toNamed(Routes.clientPaymentAndInvoice);
  }

  @override
  void onHelpAndSupportClick() {
    ClientHelpOption.show(
      context!,
      msgFromAdmin: unreadMsgFromAdmin.value,
    );
  }

  @override
  void onNotificationClick() {
    Get.toNamed(Routes.clientNotification);
  }

  void onProfileClick() {
    Get.toNamed(Routes.clientSelfProfile);
  }

  @override
  void chatWithAdmin() {
    Get.back(); // hide dialogue

    Get.toNamed(Routes.supportChat, arguments: {
      MyStrings.arg.fromId: appController.user.value.userId,
      MyStrings.arg.toId: "allAdmin",
      MyStrings.arg.supportChatDocId: appController.user.value.userId,
      MyStrings.arg.receiverName: "Support",
    });
  }

  @override
  void requestEmployees() {
    Get.back(); // hide dialogue

    Get.toNamed(Routes.clientRequestForEmployee);
  }

  void onShortlistClick() {
    Get.toNamed(Routes.clientShortlisted);
  }

  void onSuggestedEmployeesClick() {
    Get.toNamed(Routes.clientSuggestedEmployees);
  }

  void _fetchRequestEmployees() {
    _apiHelper.getRequestedEmployees(clientId: appController.user.value.userId).then((response) {
      response.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = onAccountDeleteClick);
      }, (RequestedEmployees requestedEmployees) async {
        this.requestedEmployees.value = requestedEmployees;
        this.requestedEmployees.refresh();
      });
    });
  }

  int countTotalRequestedEmployees() {
    int total = 0;

    for(RequestEmployee element in requestedEmployees.value.requestEmployees ?? []) {
      total += (element.clientRequestDetails ?? []).fold(0, (previousValue, element) => previousValue + (element.numOfEmployee ?? 0));
    }

    return total;
  }

  int countSuggestedEmployees() {
    int total = 0;

    for(RequestEmployee element in requestedEmployees.value.requestEmployees ?? []) {
      total += (element.suggestedEmployeeDetails ?? []).length;
    }

    return total;
  }

  Future<void> onAccountDeleteClick() async {
    CustomDialogue.confirmation(
      context: context!,
      title: "Confirm Delete",
      msg: "Are you sure you want to delete account? \n\n Once you delete your account you can't access and you lost all of your data",
      confirmButtonText: "Delete",
      onConfirm: () async {

        Get.back(); // hide confirmation dialog

        CustomLoader.show(context!);

        Map<String, dynamic> data = {
          "id": appController.user.value.userId,
          "active": false,
          "deactivatedReason": "Account deactivate by user(${appController.user.value.userId})"
        };

        await _apiHelper.deleteAccount(data).then((response) {
          CustomLoader.hide(context!);

          response.fold((CustomError customError) {
            Utils.errorDialog(context!, customError..onRetry = onAccountDeleteClick);
          }, (Response deleteResponse) async {
            appController.onLogoutClick();
          });

        });
      },
    );

  }

  void _trackUnreadMsg() {
    // employee massage
    FirebaseFirestore.instance.collection('employee_client_chat').where("clientId", isEqualTo: appController.user.value.userId).snapshots().listen((QuerySnapshot<Map<String, dynamic>> event) {

      unreadMsgFromEmployee.value = 0;
      employeeChatDetails.clear();

      for (var element in event.docs) {
        Map<String, dynamic> data = element.data();
        unreadMsgFromEmployee.value += data["${appController.user.value.userId}_unread"] as int;
        employeeChatDetails.add(data);
      }

      employeeChatDetails.refresh();
    });

    // admin massage
    FirebaseFirestore.instance.collection("support_chat").doc(appController.user.value.userId).snapshots().listen((DocumentSnapshot<Map<String, dynamic>> event) {
      if(event.exists) {
        Map<String, dynamic> data = event.data()!;
        unreadMsgFromAdmin.value = data["${appController.user.value.userId}_unread"];
      }
    });
  }

}
