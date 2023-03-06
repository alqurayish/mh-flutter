import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../models/employees_by_id.dart';
import '../../../../routes/app_pages.dart';
import '../../common/shortlist_controller.dart';

class EmployeeDetailsController extends GetxController {
  BuildContext? context;

  final AppController _appController = Get.find();

  late Employee employee;

  final ShortlistController shortlistController = Get.find();

  @override
  void onInit() {
    employee = Get.arguments[MyStrings.arg.data];
    super.onInit();
  }

  void onBookNowClick() {
    if(!_appController.hasPermission()) return;

    Get.toNamed(Routes.clientShortlisted);
  }
}
