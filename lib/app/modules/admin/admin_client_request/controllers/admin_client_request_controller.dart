import '../../../../common/utils/exports.dart';
import '../../../../routes/app_pages.dart';
import '../../admin_home/controllers/admin_home_controller.dart';

class AdminClientRequestController extends GetxController {
  BuildContext? context;

  AdminHomeController adminHomeController = Get.find();

  @override
  void onInit() {
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
    return adminHomeController.requestedEmployees.value.requestEmployees?[index].clientDetails?.restaurantName ?? "-";
  }

  String getSuggested(int index) {
    int total = adminHomeController.getTotalRequestByPosition(index);
    int suggested = adminHomeController.getTotalSuggestByPosition(index);
    return "Already suggested $suggested of $total";
  }

  void onItemClick(int index) {
    Get.toNamed(Routes.adminClientRequestPositions, arguments: {
      MyStrings.arg.data: index,
    });
  }

}
