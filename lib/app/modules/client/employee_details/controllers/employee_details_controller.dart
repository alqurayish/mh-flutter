import '../../../../common/utils/exports.dart';
import '../../../../models/employees_by_id.dart';
import '../../../../routes/app_pages.dart';
import '../../common/shortlist_controller.dart';

class EmployeeDetailsController extends GetxController {
  BuildContext? context;

  late Employee employee;

  final ShortlistController shortlistController = Get.find();

  @override
  void onInit() {
    employee = Get.arguments[MyStrings.arg.data];
    super.onInit();
  }

  void onBookNowClick() {
    Get.toNamed(Routes.clientShortlisted);
  }
}
