import 'package:flutter/services.dart';

import '../../enums/error_from.dart';
import '../../models/custom_error.dart';
import '../controller/app_controller.dart';
import '../widgets/custom_dialog.dart';
import 'exports.dart';

class Utils {
  static final Utils _instance = Utils._();

  factory Utils() {
    return _instance;
  }

  Utils._();

  static unFocus() => FocusManager.instance.primaryFocus?.unfocus();

  static get exitApp => SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  static Future<bool> appExitConfirmation(BuildContext context) async => CustomDialogue.appExit(context) ?? false;

  static void setStatusBarColorColor(Brightness brightness) {
    Future.delayed(const Duration(milliseconds: 1)).then(
      (value) => SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
          statusBarBrightness: brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
        ),
      ),
    );
  }

  static String dropdownItemTitle(dynamic object, String keyword) {
    return object.toJson()[keyword];
  }

  static bool get isPhone => GetPlatform.isMobile;

  static errorDialog(BuildContext context, CustomError customError) {
    if(customError.errorFrom == ErrorFrom.noInternet) {
      CustomDialogue.noInternetError(
        context: context,
        onRetry: customError.onRetry,
      );
    } else if(customError.errorFrom == ErrorFrom.api) {
      CustomDialogue.apiError(
        context: context,
        onRetry: customError.onRetry,
        errorCode: customError.errorCode,
        msg: customError.msg,
      );
    } else if(customError.errorFrom == ErrorFrom.typeConversion) {
      CustomDialogue.typeConversionError(
        context: context,
        onRetry: customError.onRetry,
      );
    }
  }

  static String calculateAge(DateTime? dateTime) {
    return( DateTime.now().year - (dateTime ?? DateTime.now()).year).toString();
  }

  static bool isPositionActive(String positionId) {
    return (Get.find<AppController>().commons?.value.positions ?? [])
        .where((element) => element.id == positionId && (element.active ?? false))
        .isNotEmpty;
  }

  static String getPositionName(String positionId) {
    var result = (Get.find<AppController>().commons?.value.positions ?? [])
        .where((element) => element.id == positionId);

    if (result.isEmpty) return "-";

    return result.first.name ?? "-";
  }

  static String getPositionId(String positionName) {
    var result = (Get.find<AppController>().commons?.value.positions ?? [])
        .where((element) => element.name == positionName);

    return result.first.id ?? "";
  }
}
