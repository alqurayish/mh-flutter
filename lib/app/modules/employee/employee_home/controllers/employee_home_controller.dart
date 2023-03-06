import 'package:slide_to_act/slide_to_act.dart';

import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../routes/app_pages.dart';

class EmployeeHomeController extends GetxController {

  BuildContext? context;

  final AppController appController = Get.find();

  final GlobalKey<SlideActionState> key = GlobalKey();

  RxBool checkIn = true.obs;
  RxBool checkOut = false.obs;


  @override
  void onDashboardClick() {
    Get.toNamed(Routes.employeeDashboard);
  }

  @override
  void onEmergencyCheckinCheckout() {
    Get.toNamed(Routes.employeeDashboard);
  }

  @override
  void onHelpAndSupportClick() {
    Get.toNamed(Routes.contactUs);
  }

  @override
  void onNotificationClick() {
    Get.toNamed(Routes.clientNotification);
  }

  void onCheckInCheckOut() {
    if(checkIn.value) {
      _onCheckIn();
    } else if(checkOut.value) {
      _onCheckout();
    }
  }

  void _onCheckIn() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        checkIn.value = false;
        checkOut.value = true;
        key.currentState?.reset();
      },
    );
  }

  void _onCheckout() {
    Future.delayed(
      const Duration(seconds: 3),
          () {
        checkIn.value = true;
        checkOut.value = false;
        key.currentState?.reset();
      },
    );
  }
}
