import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../enums/chat_with.dart';
import '../../../../models/employees_by_id.dart';
import '../../../../routes/app_pages.dart';
import '../../common/shortlist_controller.dart';

class EmployeeDetailsController extends GetxController {
  BuildContext? context;

  final AppController _appController = Get.find();

  late Employee employee;
  late bool showAsAdmin;

  final ShortlistController shortlistController = Get.find();

  @override
  void onInit() {
    employee = Get.arguments[MyStrings.arg.data];
    showAsAdmin = Get.arguments[MyStrings.arg.showAsAdmin];
    super.onInit();
  }

  Future<void> onBookNowClick() async {
    if(!_appController.hasPermission()) return;

    await shortlistController.onBookNowClick(employee.id!);

    Get.toNamed(Routes.clientShortlisted);
  }

  // only admin chat with employee
  void onChatClick() {
    Get.toNamed(Routes.supportChat, arguments: {
      MyStrings.arg.fromId: _appController.user.value.userId,
      MyStrings.arg.toId: employee.id ?? "",
      MyStrings.arg.supportChatDocId: employee.id ?? "",
      MyStrings.arg.receiverName: employee.firstName ?? "-",
    });
  }
}
