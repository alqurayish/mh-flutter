import '../../../common/utils/exports.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return WillPopScope(
      onWillPop: () => Utils.appExitConfirmation(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SplashView'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
            "MH",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
