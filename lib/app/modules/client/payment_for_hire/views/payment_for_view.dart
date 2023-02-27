import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../../../../common/widgets/custom_bottombar.dart';
import '../controllers/payment_for_hire_controller.dart';

class PaymentForHireView extends GetView<PaymentForHireController> {
  const PaymentForHireView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
      appBar: CustomAppbar.appbar(
        title: "Payment",
        context: context,
      ),
      bottomNavigationBar: _bottomBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _total,

            SizedBox(height: 20.h),

            _availablePaymentMethod,

          ],
        ),
      ),
    );
  }

  Widget get _total {
    return Container(
      height: Get.height * .2,
      width: double.infinity,
      margin: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: MyColors.c_C6A34F,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Introduction Fee",
            style: MyColors.white.regular15,
          ),

          SizedBox(height: 10.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${controller.shortlistController.getIntroductionFees()}',
                style: MyColors.white.semiBold22.copyWith(fontSize: 52),
              ),

              SizedBox(width: 10.w),

              Text(
                'USD',
                style: MyColors.white.medium12.copyWith(fontSize: 45),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget get _availablePaymentMethod {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 23.w),
      padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: MyColors.lightCard(controller.context!),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          width: .5,
          color: MyColors.c_A6A6A6,
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "Payment Options",
            style: MyColors.l111111_dwhite(controller.context!).semiBold18,
          ),

          SizedBox(height: 15.h,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _paymentMethodItem(MyAssets.paymentMethod.amex),
              _paymentMethodItem(MyAssets.paymentMethod.bitcoin),
              _paymentMethodItem(MyAssets.paymentMethod.mastercard),
              _paymentMethodItem(MyAssets.paymentMethod.paypal),
              _paymentMethodItem(MyAssets.paymentMethod.visa),
            ],
          ),

          SizedBox(height: 20.h),

          _paymentUnavailable,

          SizedBox(height: 30.h),

          Text(
            "Please submit your request. we will contact with you within 24 hours",
            textAlign: TextAlign.center,
            style: MyColors.text.regular15,
          ),
        ],
      ),
    );
  }

  Widget _paymentMethodItem(String name) {
    return Image.asset(
      name,
      width: 60.w,
      height: 50.h,
    );
  }

  Widget get _paymentUnavailable {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 23.h),
      decoration: BoxDecoration(
        color: MyColors.c_C6A34F_22,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          width: .5,
          color: MyColors.c_C6A34F,
        ),
      ),
      child: Text(
        "SORRY! Our all payment options currently unavailable.",
        // textAlign: TextAlign.center,
        style: MyColors.c_C6A34F.semiBold15,
      ),
    );
  }

  Widget _bottomBar(BuildContext context) {
    return CustomBottomBar(
        child: CustomButtons.button(
          onTap: controller.onSubmitRequestClick,
          text: "Submit Request",
          customButtonStyle: CustomButtonStyle.radiusTopBottomCorner,
        ));
  }
}
