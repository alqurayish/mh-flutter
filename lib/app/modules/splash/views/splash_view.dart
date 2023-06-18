import '../../../common/utils/exports.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return WillPopScope(
      onWillPop: () => Utils.appExitConfirmation(context),
      child: const Scaffold(
        body: Center(
            child: CircularProgressIndicator.adaptive(
          backgroundColor: MyColors.c_C6A34F,
        )),
      ),
    );
  }
}
