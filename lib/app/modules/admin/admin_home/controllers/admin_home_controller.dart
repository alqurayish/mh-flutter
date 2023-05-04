import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../models/custom_error.dart';
import '../../../../models/requested_employees.dart';
import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';

class AdminHomeController extends GetxController {
  BuildContext? context;

  final AppController appController = Get.find();
  final ApiHelper _apiHelper = Get.find();

  RxBool loading = true.obs;

  Rx<RequestedEmployees> requestedEmployees = RequestedEmployees().obs;

  // unread msg track
  CollectionReference onUnreadCollection = FirebaseFirestore.instance.collection('unreadMsg');
  RxList<dynamic> unreadFromClient = [].obs;
  RxList<dynamic> unreadFromEmployee = [].obs;

  @override
  void onInit() {
    _trackUnreadMsg();

    _fetchRequest();
    super.onInit();
  }

  @override
  void onEmployeeClick() {
    Get.toNamed(Routes.adminAllEmployees);
  }

  @override
  void onClientClick() {
    Get.toNamed(Routes.adminAllClients);
  }

  @override
  void onRequestClick() {
    Get.toNamed(Routes.adminClientRequest);
  }

  @override
  void onAdminDashboardClick() {
    Get.toNamed(Routes.adminDashboard);
  }

  int getTotalRequestByPosition(int index) {
    return (requestedEmployees.value.requestEmployees?[index].clientRequestDetails ?? []).fold(0, (previousValue, element) => previousValue + (element.numOfEmployee ?? 0));
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
    onUnreadCollection.doc(appController.user.value.userId).snapshots().listen((DocumentSnapshot doc) {
      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
      unreadFromClient.value = data["client"];
      unreadFromEmployee.value = data["employee"];

      unreadFromClient.refresh();
      unreadFromEmployee.refresh();
    });
  }
}
