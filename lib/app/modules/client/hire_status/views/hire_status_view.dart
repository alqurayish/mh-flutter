import 'package:lottie/lottie.dart';

import '../../../../common/utils/exports.dart';
import '../controllers/hire_status_controller.dart';

class HireStatusView extends GetView<HireStatusController> {
  const HireStatusView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Lottie.asset(MyAssets.lottie.registrationDone),
                Text(
                  "Payment Successfully",
                  style: MyColors.l111111_dwhite(context).semiBold22,
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: Get.back,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyColors.c_C6A34F,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.home_outlined,
                        size: 30,
                        color: MyColors.white,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        "Home",
                        style: MyColors.white.semiBold12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
