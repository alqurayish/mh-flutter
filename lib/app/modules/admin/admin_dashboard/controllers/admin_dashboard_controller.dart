import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../models/check_in_out_histories.dart';
import '../../../../models/custom_error.dart';
import '../../../../models/employee_daily_statistics.dart';
import '../../../../models/employees_by_id.dart';
import '../../../../repository/api_helper.dart';

class AdminDashboardController extends GetxController {
  BuildContext? context;

  final AppController appController = Get.find();
  final ApiHelper _apiHelper = Get.find();

  RxInt uniqueClient = 0.obs;

  RxBool historyLoading = true.obs;
  RxBool clientLoading = true.obs;

  Rx<DateTime> dashboardDate = DateTime.now().obs;

  Rx<CheckInCheckOutHistory> checkInCheckOutHistory = CheckInCheckOutHistory().obs;

  RxList<CheckInCheckOutHistoryElement> history = <CheckInCheckOutHistoryElement>[].obs;

  String? requestType = "CLIENT";
  String? clientId;

  Rx<Employees> clients = Employees().obs;
  RxList<String> restaurants = ["ALL"].obs;

  RxInt totalWorkingTimeInMinutes = 0.obs;
  RxDouble amount = 0.0.obs;

  @override
  void onInit() {
    _fetchClients();
    _fetchCheckInOutHistory();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  UserDailyStatistics dailyStatistics(int index) => Utils.checkInOutToStatistics(history[index]);

  void onDatePicked(DateTime dateTime) {
    dashboardDate.value = dateTime;
    dashboardDate.refresh();

    _fetchCheckInOutHistory();
  }

  @override
  void onClientChange(String? value) {
    if(value == restaurants.first) {
      clientId = null;
    } else {
      clientId = (clients.value.users ?? []).firstWhere((element) => element.restaurantName == value).id;
    }

    _fetchCheckInOutHistory();
  }

  Future<void> _fetchCheckInOutHistory() async {
    historyLoading.value = true;

    await _apiHelper.getCheckInOutHistory(
      filterDate: dashboardDate.value.toString().split(" ").first,
      clientId: clientId,
    ).then((response) {

      historyLoading.value = false;

      response.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _fetchCheckInOutHistory);
      }, (CheckInCheckOutHistory checkInCheckOutHistory) async {

        this.checkInCheckOutHistory.value = checkInCheckOutHistory;
        history..clear()..addAll(checkInCheckOutHistory.checkInCheckOutHistory ?? []);

        _updateSummary();
      });
    });
  }

  Future<void> _fetchClients() async {
    clientLoading.value = true;

    await _apiHelper.getAllUsersFromAdmin(
      requestType: "CLIENT",
    ).then((response) {

      clientLoading.value = false;

      response.fold((CustomError customError) {

        Utils.errorDialog(context!, customError..onRetry = _fetchClients);

      }, (Employees clients) {

        this.clients.value = clients;
        this.clients.refresh();

        restaurants.addAll((clients.users ?? []).map((e) => e.restaurantName!).toList());

      });
    });
  }

  void _updateSummary() {
    var uniqueRestaurant = <String>{};

    for(int i = 0; i < history.length; i++) {
      CheckInCheckOutHistoryElement element = history[i];
      uniqueRestaurant.add(element.hiredBy!);

      UserDailyStatistics s = dailyStatistics(i);

      totalWorkingTimeInMinutes.value += s.totalWorkingTimeInMinute;
      amount.value += double.parse(s.amount);

    }


    uniqueClient.value = uniqueRestaurant.length;
  }
}
