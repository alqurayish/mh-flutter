import '../../../../common/style/my_decoration.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../../../../models/position.dart';
import '../controllers/mh_employees_controller.dart';

class MhEmployeesView extends GetView<MhEmployeesController> {
  const MhEmployeesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return WillPopScope(
      onWillPop: () => controller.appController.user.value.isClient
          ? Future.value(true)
          : Utils.appExitConfirmation(context),
      child: Scaffold(
        appBar: CustomAppbar.appbar(
          title: " Employees",
          context: context,
          visibleMH: true,
          visibleBack: controller.appController.user.value.isClient,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [

                SizedBox(height: 20.h),

                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  spacing: Get.width - (
                    20 + 20 // horizontal padding (left + right)
                    + 182.w + 182.w // item width (2 items)
                  ),
                  runSpacing: 20,
                  children: [
                    ...controller.appController.allActivePositions.map((e) {
                      return _item(e);
                    }),
                  ],
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(Position position) {
    return Container(
      width: 182.w,
      height: 112.w,
      decoration: MyDecoration.cardBoxDecoration(context: controller.context!),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () => controller.onPositionClick(position),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                position.logo!,
                width: 50.w,
                height: 50.w,
              ),
              SizedBox(height: 9.h),

              Text(
                position.name ?? "-",
                style: MyColors.l111111_dwhite(controller.context!).medium14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
