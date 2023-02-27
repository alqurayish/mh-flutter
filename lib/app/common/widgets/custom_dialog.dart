import 'package:lottie/lottie.dart';

import '../utils/exports.dart';
import 'custom_loader.dart';

class CustomDialogue {

  static Future noInternetError({
    required BuildContext context,
    Function()? onRetry,
  }) =>
      _errorDialog(
        context: context,
        onRetry: onRetry,
        logo: MyAssets.lottie.noWifi,
        title: "No Internet Connection",
        details: "This is a connection error. Please check you internet connection and try again",
      );

  static Future apiError({
    required BuildContext context,
    Function()? onRetry,
    required int errorCode,
    String? msg,
  }) =>
      _errorDialog(
        context: context,
        onRetry: onRetry,
        logo: MyAssets.lottie.serverError,
        title: "Server Error $errorCode",
        details: msg ?? "Something happen with our server. Please try again or keep patient for some time",
      );

  static Future typeConversionError({
    required BuildContext context,
    Function()? onRetry,
  }) =>
      _errorDialog(
        context: context,
        onRetry: onRetry,
        logo: MyAssets.lottie.error,
        title: "OOPS!",
        details: "Something mismatch! Please try again or contact with our customer care",
      );

  static Future _errorDialog({
    required BuildContext context,
    Function()? onRetry,
    required String logo,
    required String title,
    required String details,
  }) => Future.delayed(
    Duration.zero,
        () {
      return Get.dialog(
        WillPopScope(
          onWillPop: () async => true,
          child: Align(
            alignment: Alignment.center,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                height: Get.height * .45,
                width: Get.height * .4,
                decoration: BoxDecoration(
                  color: MyColors.lightCard(context),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Lottie.asset(logo),
                        ),
                      ),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              style: MyColors.l111111_dtext(context).semiBold22,
                            ),

                            SizedBox(height: 30.h),

                            Text(
                              details,
                              textAlign: TextAlign.center,
                              style: MyColors.l50555C_dtext(context).regular15,
                            ),
                          ],
                        ),
                      ),


                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: CustomButtons.button(
                            height: 50.h,
                            text: onRetry == null ? "Close" : "Retry",
                            customButtonStyle: CustomButtonStyle.radiusTopBottomCorner,
                            onTap: () {
                              CustomLoader.hide(context);

                              if(onRetry == null) {
                                CustomLoader.hide(context);
                              } else {
                                onRetry();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
    },
  );

  static Future information({
    required BuildContext context,
    required  String title,
    required String description,
  }) => Future.delayed(
    Duration.zero,
        () {
      return Get.dialog(
        WillPopScope(
          onWillPop: () async => true,
          child: Align(
            alignment: Alignment.center,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                height: Get.height * (description.length < 100 ? .32 : .45),
                width: Get.height * .4,
                decoration: BoxDecoration(
                  color: MyColors.lightCard(context),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      SizedBox(height: 25.h),

                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: MyColors.l111111_dtext(context).semiBold22,
                      ),

                      SizedBox(height: 30.h),

                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            description,
                            textAlign: TextAlign.center,
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                            style: MyColors.l50555C_dtext(context).regular15,
                          ),
                        ),
                      ),

                      SizedBox(height: 15.h),

                      CustomButtons.button(
                        height: 50.h,
                        text: "I understand",
                        customButtonStyle: CustomButtonStyle.radiusTopBottomCorner,
                        onTap: () {
                          CustomLoader.hide(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
    },
  );

  static dynamic appExit(BuildContext context) {
    Future.delayed(
      Duration.zero,
          () {
        return Get.dialog(
          WillPopScope(
            onWillPop: () async => true,
            child: Align(
              alignment: Alignment.center,
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  height: Get.height * .3,
                  width: Get.height * .4,
                  decoration: BoxDecoration(
                    color: MyColors.lightCard(context),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        SizedBox(height: 25.h),

                        Text(
                          "Exit App?",
                          textAlign: TextAlign.center,
                          style: MyColors.l111111_dtext(context).semiBold22,
                        ),

                        SizedBox(height: 30.h),

                        Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              "Are you sure you want to exit?",
                              textAlign: TextAlign.center,
                              maxLines: 10,
                              overflow: TextOverflow.ellipsis,
                              style: MyColors.l50555C_dtext(context).regular15,
                            ),
                          ),
                        ),

                        SizedBox(height: 15.h),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  CustomLoader.hide(context);
                                },
                                child: Text(
                                  "CLOSE",
                                  style: MyColors.text.semiBold16,
                                ),
                              ),
                              const SizedBox(width: 40),
                              Expanded(
                                child: CustomButtons.button(
                                  height: 50.h,
                                  text: "Exit",
                                  margin: EdgeInsets.zero,
                                  customButtonStyle:
                                      CustomButtonStyle.radiusTopBottomCorner,
                                  onTap: () {
                                    Utils.exitApp;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          barrierDismissible: false,
        );
      },
    );
  }
}
