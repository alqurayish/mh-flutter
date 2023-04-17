import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_loader.dart';
import '../../../../models/custom_error.dart';
import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';
import '../../common/shortlist_controller.dart';

class PaymentForHireController extends GetxController {
  BuildContext? context;

  final ShortlistController shortlistController = Get.find();

  final ApiHelper _apiHelper = Get.find();

  final AppController appController = Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> onSubmitRequestClick() async {
    List<String> shortlistIds = [];

    for (var element in shortlistController.selectedForHire) {
      shortlistIds.add(element.sId!);
    }

    CustomLoader.show(context!);

    await _apiHelper.hireConfirm({"selectedShortlist": shortlistIds}).then((response) {

      CustomLoader.hide(context!);

      response.fold((CustomError customError) {

        Utils.errorDialog(context!, customError..onRetry = onSubmitRequestClick);

      }, (r) {
        shortlistController.fetchShortListEmployees();
        shortlistController.selectedForHire..clear()..refresh();
        Get.until((route) => Get.currentRoute == Routes.clientHome);
        Get.toNamed(Routes.hireStatus);
      });
    });
  }

}
