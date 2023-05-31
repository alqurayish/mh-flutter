import '../../../common/app_info/app_info.dart';
import '../../../common/controller/app_controller.dart';
import '../../../common/utils/exports.dart';
import '../../../common/widgets/custom_dialog.dart';
import '../../../models/commons.dart';
import '../../../models/custom_error.dart';
import '../../../repository/api_helper.dart';

class SplashController extends GetxController {

  BuildContext? context;

  final ApiHelper _apiHelper = Get.find();
  final AppController _appController = Get.find();

  @override
  void onReady() {
    _initialize();
    super.onReady();
  }

  void _initialize() {
    Future.delayed(const Duration(seconds: 1), _getCommonData);
  }

  Future<void> _goToNextPage() async {
    _appController.setTokenFromLocal();
  }

  Future<void> _getCommonData() async {
    await _apiHelper.commons().then((response) {
      response.fold((CustomError customError) {

        Utils.errorDialog(context!, customError..onRetry = _getCommonData);

      }, (Commons commons) {
        _appController.setCommons(commons);

        if(commons.appVersion!.first.serverMaintenance!) {
          CustomDialogue.information(
            context: context!,
            title: "Server Maintenance",
            description: commons.appVersion!.first.serverMaintenanceMsg ?? "We will online soon",
            buttonText: "Exit",
            onTap: () {
              Utils.exitApp;
            },
          );
        } else if ((commons.appVersion!.first.showUpdateDialog ?? false) && (commons.appVersion!.first.appVersion != AppInfo.version)) {
          CustomDialogue.information(
            context: context!,
            title: "New version Available",
            description: "New version ${commons.appVersion!.first.appVersion} is released. ${(commons.appVersion!.first.updateRequired ?? false) ? "Please update your app and continue" : "please update your app for better experience"}",
            buttonText: (commons.appVersion!.first.updateRequired ?? false) ? "Exit" : "I Understand",
            onTap: () {
              if ((commons.appVersion!.first.updateRequired ?? false)) {
                Utils.exitApp;
              } else {
                _goToNextPage();
              }
            },
          );
        } else {
          _goToNextPage();
        }

      });
    });
  }
}
