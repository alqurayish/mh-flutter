import '../../../../common/utils/exports.dart';
import '../../../../models/custom_error.dart';
import '../../../../models/requested_employees.dart';
import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';

class AdminClientRequestController extends GetxController {
  BuildContext? context;

  final ApiHelper _apiHelper = Get.find();

  RxBool loading = true.obs;

  Rx<RequestedEmployees> requestedEmployees = RequestedEmployees().obs;


  @override
  void onInit() {
    _fetchRequest();
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

  String getRestaurantName(int index) {
    return requestedEmployees.value.requestEmployees?[index].clientDetails?.restaurantName ?? "-";
  }

  String getSuggested(int index) {
    int total = (requestedEmployees.value.requestEmployees?[index].clientRequestDetails ?? []).fold(0, (previousValue, element) => previousValue + (element.numOfEmployee ?? 0));
    int suggested = requestedEmployees.value.requestEmployees?[index].suggestedEmployeeDetails?.length ?? 0;
    return "Already suggested $suggested of $total";
  }

  void onItemClick(int index) {
    Get.toNamed(Routes.adminClientRequestPositions, arguments: {
      MyStrings.arg.data: index,
    });
  }

  Future<void> reloadPage() async {
    await _fetchRequest();
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

}
