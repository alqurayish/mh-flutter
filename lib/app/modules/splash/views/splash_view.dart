import 'package:mh/app/common/widgets/custom_loader.dart';

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
        body: Center(child: CustomLoader.loading()),
      ),
    );
  }
}
