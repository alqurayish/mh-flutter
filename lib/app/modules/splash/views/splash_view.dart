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
            child: CircularProgressIndicator(
          color: MyColors.c_C6A34F,
        )),
      ),
    );
  }
}
