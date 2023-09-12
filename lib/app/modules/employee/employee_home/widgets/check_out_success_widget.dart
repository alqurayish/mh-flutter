import 'package:lottie/lottie.dart';
import 'package:mh/app/common/utils/exports.dart';
import 'package:mh/app/routes/app_pages.dart';

class CheckOutSuccessWidget extends StatelessWidget {
  const CheckOutSuccessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.45,
      decoration: BoxDecoration(
        color: MyColors.lightCard(context),
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Lottie.asset(MyAssets.lottie.successLottie, height: 150.w, width: 150.w),
            Text('You have successfully checkedOut', style: MyColors.l111111_dwhite(context).semiBold18),
            //SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButtons.button(
                    padding: EdgeInsets.symmetric(horizontal: 40.0.w),
                    margin: EdgeInsets.zero,
                    height: 40.h,
                    backgroundColor: Colors.grey.shade400,
                    text: 'Close', onTap: () => Get.back(), customButtonStyle: CustomButtonStyle.radiusTopBottomCorner),
                CustomButtons.button(
                  height: 40.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                  margin: EdgeInsets.zero,
                    text: 'Dashboard',
                    customButtonStyle: CustomButtonStyle.radiusTopBottomCorner,
                    onTap: () => Get.toNamed(Routes.employeeDashboard)!.then((value){
                      Get.back();
                    }))
              ],
            )
          ],
        ),
      ),
    );
  }
}
