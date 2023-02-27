import '../../../common/controller/app_controller.dart';
import '../../../common/helper/auth_helper.dart';
import '../../../common/utils/exports.dart';
import '../../../models/commons.dart';
import '../../../models/custom_error.dart';
import '../../../repository/api_helper.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {

  BuildContext? context;

  final ApiHelper _apiHelper = Get.find();
  final AppController _appController = Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    _initialize();
    super.onReady();
  }

  void _initialize() {
    Future.delayed(const Duration(seconds: 1), _getCommonData);
  }

  Future<void> _goToNextPage() async {
    await _isLocalTokenValid() ? _goToHomePage() : _goToLoginRegisterHintPage();
  }

  Future<bool> _isLocalTokenValid() async {
    return await AuthHelper.getUserFromLocal().then((response) {
      return response.fold((l) => false, (r) => true);
    });
  }

  void _goToHomePage() {
    _appController.activeShortlistService();
    Get.offAndToNamed(_appController.user.value.userType!.homeRoute);
  }

  void _goToLoginRegisterHintPage() {
    Get.offAndToNamed(Routes.loginRegisterHints);
  }

  Future<void> _getCommonData() async {
    await _apiHelper.commons().then((response) {
      response.fold((CustomError customError) {

        Utils.errorDialog(context!, customError..onRetry = _getCommonData);

      }, (Commons commons) {
        _appController.setCommons(commons);

        _goToNextPage();

      });
    });
  }
}
